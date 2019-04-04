# Solidity Smart Contracts

All code for our smart contracts can be found [here](https://github.com/MARKETProtocol/MARKETProtocol). If you have any
issues to report please do so by opening an issue on [GitHub](https://github.com/MARKETProtocol/MARKETProtocol/issues).

## Market Contract

> MarketContract constructor:

```javascript
/// @param contractNames comma separated list of 3 names "contractName,longTokenSymbol,shortTokenSymbol"
/// @param baseAddresses array of 2 addresses needed for our contract including:
///     creatorAddress                  address of the person creating the contract
///     collateralTokenAddress          address of the ERC20 token that will be used for collateral and pricing
///     collateralPoolAddress           address of our collateral pool contract
/// @param contractSpecs array of unsigned integers including:
///     floorPrice          minimum tradeable price of this contract, contract enters settlement if breached
///     capPrice            maximum tradeable price of this contract, contract enters settlement if breached
///     priceDecimalPlaces  number of decimal places to convert our queried price from a floating point to
///                         an integer
///     qtyMultiplier       multiply traded qty by this value from base units of collateral token.
///     feeInBasisPoints    fee amount in basis points (Collateral token denominated) for minting.
///     mktFeeInBasisPoints fee amount in basis points (MKT denominated) for minting.
///     expirationTimeStamp seconds from epoch that this contract expires and enters settlement
constructor(
    string memory contractNames,
    address[3] memory baseAddresses,
    uint[7] memory contractSpecs
) public
{
    PRICE_FLOOR = contractSpecs[0];
    PRICE_CAP = contractSpecs[1];
    require(PRICE_CAP > PRICE_FLOOR);

    PRICE_DECIMAL_PLACES = contractSpecs[2];
    QTY_MULTIPLIER = contractSpecs[3];
    EXPIRATION = contractSpecs[6];
    require(EXPIRATION > now, "expiration must be in the future");

    COLLATERAL_TOKEN_ADDRESS = baseAddresses[1];
    COLLATERAL_POOL_ADDRESS = baseAddresses[2];
    COLLATERAL_PER_UNIT = MathLib.calculateTotalCollateral(PRICE_FLOOR, PRICE_CAP, QTY_MULTIPLIER);
    COLLATERAL_TOKEN_FEE_PER_UNIT = MathLib.calculateFeePerUnit(
        PRICE_FLOOR,
        PRICE_CAP,
        QTY_MULTIPLIER,
        contractSpecs[4]
    );
    MKT_TOKEN_FEE_PER_UNIT = MathLib.calculateFeePerUnit(
        PRICE_FLOOR,
        PRICE_CAP,
        QTY_MULTIPLIER,
        contractSpecs[5]
    );

    // create long and short tokens
    StringLib.slice memory pathSlice = contractNames.toSlice();
    StringLib.slice memory delim = ",".toSlice();
    require(pathSlice.count(delim) == 2, "ContractNames must contain 3 names");  //contractName,lTokenName,sTokenName
    CONTRACT_NAME = pathSlice.split(delim).toString();

    PositionToken longPosToken = new PositionToken("MARKET Protocol Long Position Token", pathSlice.split(delim).toString(), 0);
    PositionToken shortPosToken = new PositionToken("MARKET Protocol Short Position Token", pathSlice.split(delim).toString(), 1);

    LONG_POSITION_TOKEN = address(longPosToken);
    SHORT_POSITION_TOKEN = address(shortPosToken);

    transferOwnership(baseAddresses[0]);
}
```

The `MarketContract` represents the main contract responsible for defining trading specifications as well as creating
a set of ERC20 tokens known as Market Protocol Position Tokens.  One of these tokens represents a long position or exposure
and the other, the opposite, short exposure. Combined with MARKET Protocol's collateral pool 
these provide all of the needed functionality for trading, settlement and position management.  

![Contract Diagram](/images/MARKET_Protocol-SmartContracts.png)

`MarketContract` is an abstract contract that will allow for implementing 
classes such as `MarketContractMPX` to complete the needed top level functionality of integrating multiple oracle solutions.
We intend to expand the offering of oracle solutions in the future.  

## Market Contract MPX

> MarketContractMPX constructor:

```javascript
/// @param contractNames comma separated list of 3 names "contractName,longTokenSymbol,shortTokenSymbol"
/// @param baseAddresses array of 2 addresses needed for our contract including:
///     creatorAddress                  address of the person creating the contract
///     collateralTokenAddress          address of the ERC20 token that will be used for collateral and pricing
///     collateralPoolAddress           address of our collateral pool contract
/// @param oracleHubAddress     address of our oracle hub providing the callbacks
/// @param contractSpecs array of unsigned integers including:
///     floorPrice              minimum tradeable price of this contract, contract enters settlement if breached
///     capPrice                maximum tradeable price of this contract, contract enters settlement if breached
///     priceDecimalPlaces      number of decimal places to convert our queried price from a floating point to
///                             an integer
///     qtyMultiplier           multiply traded qty by this value from base units of collateral token.
///     feeInBasisPoints    fee amount in basis points (Collateral token denominated) for minting.
///     mktFeeInBasisPoints fee amount in basis points (MKT denominated) for minting.
///     expirationTimeStamp     seconds from epoch that this contract expires and enters settlement
/// @param oracleURL url of data
/// @param oracleStatistic statistic type (lastPrice, vwap, etc)
constructor(
    string memory contractNames,
    address[3] memory baseAddresses,
    address oracleHubAddress,
    uint[7] memory contractSpecs,
    string memory oracleURL,
    string memory oracleStatistic
) MarketContract(
    contractNames,
    baseAddresses,
    contractSpecs
)  public
{
    ORACLE_URL = oracleURL;
    ORACLE_STATISTIC = oracleStatistic;
    ORACLE_HUB_ADDRESS = oracleHubAddress;
}
```

`MarketContractMPX` is the first fully implemented `MarketContract` that has been built out.  Using our internal oracle
service built for MPX our initial contracts will settle to price feeds graciously provided by [CoinCap](https://coincap.io/);


### Additional parameters 

Parameter | Description
--------- |  -----------
oracleURL | URL of the api providing settlement price feed. 
oracleStatistic | The price statistic the contract will be settling to from the API 


## Market Collateral Pool

> MarketCollateralPool constructor:

```javascript
constructor(address marketContractRegistryAddress, address mktTokenAddress) public {
    marketContractRegistry = marketContractRegistryAddress;
    mktToken = mktTokenAddress;
}
```

The `MarketCollateralPool` is a contract responsible for locking required collateral tokens in order to facilitate minting
of our MARKET Protocol Position Tokens.  The exact ERC20 token that is accepted as collateral will be specified
in each `MarketContract` specification.  These collateral balances are segregated and unique to the specific
`MarketContract` that tokens have been created for.

## Minting and Redemption

### Minting Position Tokens  

> mintPositionTokens function

```javascript
/// @notice Called by a user that would like to mint a new set of long and short token for a specified
/// market contract.  This will transfer and lock the correct amount of collateral into the pool
/// and issue them the requested qty of long and short tokens
/// @param marketContractAddress            address of the market contract to redeem tokens for
/// @param qtyToMint                      quantity of long / short tokens to mint.
/// @param isAttemptToPayInMKT            if possible, attempt to pay fee's in MKT rather than collateral tokens
function mintPositionTokens(
    address marketContractAddress,
    uint qtyToMint,
    bool isAttemptToPayInMKT
) external onlyWhiteListedAddress(marketContractAddress)
{

    MarketContract marketContract = MarketContract(marketContractAddress);
    require(!marketContract.isSettled(), "Contract is already settled");

    address collateralTokenAddress = marketContract.COLLATERAL_TOKEN_ADDRESS();
    uint neededCollateral = MathLib.multiply(qtyToMint, marketContract.COLLATERAL_PER_UNIT());
    // the user has selected to pay fees in MKT and those fees are non zero (allowed) OR
    // the user has selected not to pay fees in MKT, BUT the collateral token fees are disabled (0) AND the
    // MKT fees are enabled (non zero).  (If both are zero, no fee exists)
    bool isPayFeesInMKT = (isAttemptToPayInMKT &&
        marketContract.MKT_TOKEN_FEE_PER_UNIT() != 0) ||
        (!isAttemptToPayInMKT &&
        marketContract.MKT_TOKEN_FEE_PER_UNIT() != 0 &&
        marketContract.COLLATERAL_TOKEN_FEE_PER_UNIT() == 0);

    uint feeAmount;
    uint totalCollateralTokenTransferAmount;
    address feeToken;
    if (isPayFeesInMKT) { // fees are able to be paid in MKT
        feeAmount = MathLib.multiply(qtyToMint, marketContract.MKT_TOKEN_FEE_PER_UNIT());
        totalCollateralTokenTransferAmount = neededCollateral;
        feeToken = mktToken;

        // EXTERNAL CALL - transferring ERC20 tokens from sender to this contract.  User must have called
        // ERC20.approve in order for this call to succeed.
        ERC20(mktToken).safeTransferFrom(msg.sender, address(this), feeAmount);
    } else { // fee are either zero, or being paid in the collateral token
        feeAmount = MathLib.multiply(qtyToMint, marketContract.COLLATERAL_TOKEN_FEE_PER_UNIT());
        totalCollateralTokenTransferAmount = neededCollateral.add(feeAmount);
        feeToken = collateralTokenAddress;
        // we will transfer collateral and fees all at once below.
    }

    // EXTERNAL CALL - transferring ERC20 tokens from sender to this contract.  User must have called
    // ERC20.approve in order for this call to succeed.
    ERC20(marketContract.COLLATERAL_TOKEN_ADDRESS()).safeTransferFrom(msg.sender, address(this), totalCollateralTokenTransferAmount);

    if (feeAmount != 0) {
        // update the fee's collected balance
        feesCollectedByTokenAddress[feeToken] = feesCollectedByTokenAddress[feeToken].add(feeAmount);
    }

    // Update the collateral pool locked balance.
    contractAddressToCollateralPoolBalance[marketContractAddress] = contractAddressToCollateralPoolBalance[
        marketContractAddress
    ].add(neededCollateral);

    // mint and distribute short and long position tokens to our caller
    marketContract.mintPositionTokens(qtyToMint, msg.sender);

    emit TokensMinted(
        marketContractAddress,
        msg.sender,
        feeToken,
        qtyToMint,
        neededCollateral,
        feeAmount
    );
}
```

At any time prior to expiration of the `MarketContract` a user may mint Position Tokens.  The minting process
requires users to create tokens in pairs, minting both a Long Position Token and a Short Position Token in equal 
quantities.  The Position Tokens are ERC20 tokens are able to be transferred and traded on centralized or decentralized
exchanges freely.  The required amount of collateral to mint a pair of tokens is always constant for given `MarketContract`.

### Calculating collateral per pair of tokens 

> calculateTotalCollateral function

```javascript
/// @notice determines the amount of needed collateral for minting a long and short position token
function calculateTotalCollateral(
    uint priceFloor,
    uint priceCap,
    uint qtyMultiplier
) pure public returns (uint)
{
    return multiply(subtract(priceCap, priceFloor), qtyMultiplier);
}
``` 

The amount of ERC20 collateral that is required to mint a pair of Position Tokens can be calculated by the taking the 
difference of `priceCap` from the `priceFloor` multiplied by a `qtyMultiplier`.  All three of these variables are defined
upon the deployment of a new `MarketContract`. This amount represents the entire possible range of trading outcomes at 
settlement.  A pair of Long and Short Position Tokens will always be worth this amount, and in fact can be redeemed
for that amount at any time.  For every unit of collateral that the Long Position Token may gain, the Short Position
Token by definition will lose.  In this way the pair of tokens is always zero-sum and a holder of both of these tokens 
has no net exposure to the underlying assets price, they are essentially perfectly hedged.  Users wishing to gain
exposure, either long or short, will simply either purchase that specific token on a secondary market (an exchange) or
mint the pair and sell away the unwanted side.
 
Parameter | Description
--------- |  -----------
priceFloor | as defined in the `MarketContract` 
priceCap | as defined in the `MarketContract` 
qtyMultiplier | as defined in the `MarketContract`

### Redeeming Position Tokens 

> redeemPositionTokens function

```javascript
/// @notice Called by a user that currently holds both short and long position tokens and would like to redeem them
/// for their collateral.
/// @param marketContractAddress            address of the market contract to redeem tokens for
/// @param qtyToRedeem                      quantity of long / short tokens to redeem.
function redeemPositionTokens(
    address marketContractAddress,
    uint qtyToRedeem
) external onlyWhiteListedAddress(marketContractAddress)
{
    MarketContract marketContract = MarketContract(marketContractAddress);

    marketContract.redeemLongToken(qtyToRedeem, msg.sender);
    marketContract.redeemShortToken(qtyToRedeem, msg.sender);

    // calculate collateral to return and update pool balance
    uint collateralToReturn = MathLib.multiply(qtyToRedeem, marketContract.COLLATERAL_PER_UNIT());
    contractAddressToCollateralPoolBalance[marketContractAddress] = contractAddressToCollateralPoolBalance[
        marketContractAddress
    ].subtract(collateralToReturn);

    // EXTERNAL CALL
    // transfer collateral back to user
    ERC20(marketContract.COLLATERAL_TOKEN_ADDRESS()).safeTransfer(msg.sender, collateralToReturn);

    emit TokensRedeemed(
        marketContractAddress,
        msg.sender,
        qtyToRedeem,
        collateralToReturn,
        uint8(MarketSide.Both)
    );
}
```

At any time, holders of Position Tokens can redeem equal amounts of Long and Short Position Tokens for the full
amount of collateral that was used to create them.

### Redeeming Position Tokens after Settlement

```javascript
// @notice called by a user after settlement has occurred.  This function will finalize all accounting around any
// outstanding positions and return all remaining collateral to the caller. This should only be called after
// settlement has occurred.
/// @param marketContractAddress address of the MARKET Contract being traded.
/// @param qtyToRedeem signed qtyToRedeem, positive (+) for long tokens, negative(-) for short tokens
function settleAndClose(
    address marketContractAddress,
    int qtyToRedeem
) external onlyWhiteListedAddress(marketContractAddress)
{
    MarketContract marketContract = MarketContract(marketContractAddress);
    require(marketContract.isPostSettlementDelay(), "Contract is not past settlement delay");

    // burn tokens being redeemed.
    MarketSide marketSide;
    uint absQtyToRedeem = qtyToRedeem.abs(); // convert to a uint for non signed functions
    if (qtyToRedeem > 0) {
        marketSide = MarketSide.Long;
        marketContract.redeemLongToken(absQtyToRedeem, msg.sender);
    } else {
        marketSide = MarketSide.Short;
        marketContract.redeemShortToken(absQtyToRedeem, msg.sender);
    }

    // calculate amount of collateral to return and update pool balances
    uint collateralToReturn = MathLib.calculateNeededCollateral(
        marketContract.PRICE_FLOOR(),
        marketContract.PRICE_CAP(),
        marketContract.QTY_MULTIPLIER(),
        qtyToRedeem,
        marketContract.settlementPrice()
    );

    contractAddressToCollateralPoolBalance[marketContractAddress] = contractAddressToCollateralPoolBalance[
        marketContractAddress
    ].subtract(collateralToReturn);

    // return collateral tokens
    ERC20(marketContract.COLLATERAL_TOKEN_ADDRESS()).safeTransfer(msg.sender, collateralToReturn);

    emit TokensRedeemed(
        marketContractAddress,
        msg.sender,
        absQtyToRedeem,
        collateralToReturn,
        uint8(marketSide)
    );
}
```

After settlement has occurred, plus a brief delay of 24 hours to ensure accuracy of settlement pricing, holders of *either*
Short or Long Position Tokens are able to redeem their tokens.  Position Token holders will be allocated the correct amount
of collateral back based on the settlement price of the contract, for every unit of collateral a holder of a Long Position Token
made, the holder of the Short Position Token will have lost (or vise versa). 

## Trading Position Tokens

Position Tokens are ERC20 tokens and are therefore tradeable anywhere they are listed, including our platform [MPX](https://mpexchange.io)
