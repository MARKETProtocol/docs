# Solidity Smart Contracts

All code for our smart contracts can be found [here](https://github.com/MARKETProtocol/MARKETProtocol). If you have any
issues to report please do so by opening an issue on [GitHub](https://github.com/MARKETProtocol/MARKETProtocol/issues).

## Market Contract

> MarketContract constructor:

```javascript
/// @param contractName viewable name of this contract (BTC/ETH, LTC/ETH, etc)
/// @param creatorAddress address of the person creating the contract
/// @param marketTokenAddress address of our member token
/// @param collateralTokenAddress address of the ERC20 token that will be used for collateral and pricing
/// @param collateralPoolFactoryAddress address of the factory creating the collateral pools
/// @param contractSpecs array of unsigned integers including:
/// floorPrice minimum tradeable price of this contract, contract enters settlement if breached
/// capPrice maximum tradeable price of this contract, contract enters settlement if breached
/// priceDecimalPlaces number of decimal places to convert our queried price from a floating point to
/// an integer
/// qtyMultiplier multiply traded qty by this value from base units of collateral token.
/// expirationTimeStamp - seconds from epoch that this contract expires and enters settlement
constructor(
    string contractName,
    address creatorAddress,
    address marketTokenAddress,
    address collateralTokenAddress,
    address collateralPoolFactoryAddress,
    uint[5] contractSpecs
) public
{
    COLLATERAL_POOL_FACTORY_ADDRESS = collateralPoolFactoryAddress;
    MKT_TOKEN_ADDRESS = marketTokenAddress;
    MKT_TOKEN = MarketToken(marketTokenAddress);
    require(MKT_TOKEN.isBalanceSufficientForContractCreation(msg.sender));    // creator must be MKT holder
    PRICE_FLOOR = contractSpecs[0];
    PRICE_CAP = contractSpecs[1];
    require(PRICE_CAP > PRICE_FLOOR);

    PRICE_DECIMAL_PLACES = contractSpecs[2];
    QTY_MULTIPLIER = contractSpecs[3];
    EXPIRATION = contractSpecs[4];
    require(EXPIRATION > now);

    CONTRACT_NAME = contractName;
    COLLATERAL_TOKEN_ADDRESS = collateralTokenAddress;
    creator = creatorAddress;
}
```

The `MarketContract` represents the main contract responsible for 
combining needed functionality for trading, settlement and position management.  Each `MarketContract` 
must be paired with a unique `MarketCollateralPool` ([see below](#collateral-pool)) after instantiation in order to allow trading to become
enabled.

![Contract Diagram](/images/MARKET_Protocol-SmartContracts.png)

`MarketContract` is an abstract contract that will allow for implementing 
classes such as `MarketContractOraclize` to complete the needed top level functionality around oracle solutions.
We intend to expand our offering of oracle solutions offered in the near future.  

<aside class="notice">
If there are oracle services that
you would like to submit for possible inclusion in these future plans, please email info@marketprotocol.io
</aside>

### Oracle Costs

The `Creator` of the `MarketContract` must pre-fund the contract with enough ETH in order to pay for the gas costs
associated with the needed oracle query.  Currently from Oraclize.it - the first query for any contract is free,
so this need has been removed.

Parameter | Description
--------- |  -----------
contractName | viewable name of this contract, in the future we will implement suggested naming conventions 
marketTokenAddress | address of the MKT deployed ERC20 token
collateralTokenAddress | address of the ERC20 token that will be used for collateral
contractSpecs | array of unsigned integers including the below parameters
floorPrice | minimum tradeable price of this contract
capPrice | maximum tradeable price of this contract
expirationTimeStamp |  seconds from epoch that this contract expires and enters settlement


## Market Contract Oraclize

> MarketContractOraclize constructor:

```javascript
/// @param contractName viewable name of this contract (BTC/ETH, LTC/ETH, etc)
/// @param creatorAddress address of the person creating the contract
/// @param marketTokenAddress address of our member token
/// @param collateralTokenAddress address of the ERC20 token that will be used for collateral and pricing
/// @param collateralPoolFactoryAddress address of the factory creating the collateral pools
/// @param contractSpecs array of unsigned integers including:
/// floorPrice minimum tradeable price of this contract, contract enters settlement if breached
/// capPrice maximum tradeable price of this contract, contract enters settlement if breached
/// priceDecimalPlaces number of decimal places to convert our queried price from a floating point to
/// an integer
/// qtyMultiplier multiply traded qty by this value from base units of collateral token.
/// expirationTimeStamp - seconds from epoch that this contract expires and enters settlement
/// @param oracleDataSource a data-source such as "URL", "WolframAlpha", "IPFS"
/// see http://docs.oraclize.it/#ethereum-quick-start-simple-query
/// @param oracleQuery see http://docs.oraclize.it/#ethereum-quick-start-simple-query for examples
constructor(
    string contractName,
    address creatorAddress,
    address marketTokenAddress,
    address collateralTokenAddress,
    address collateralPoolFactoryAddress,
    uint[5] contractSpecs,
    string oracleDataSource,
    string oracleQuery
) MarketContract(
    contractName,
    creatorAddress,
    marketTokenAddress,
    collateralTokenAddress,
    collateralPoolFactoryAddress,
    contractSpecs
)  public
{
    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    ORACLE_DATA_SOURCE = oracleDataSource;
    ORACLE_QUERY = oracleQuery;
    require(EXPIRATION > now);         // Require expiration time in the future.

    // Future timestamp must be within 60 days from now.
    // https://docs.oraclize.it/#ethereum-quick-start-schedule-a-query-in-the-future
    uint secondsPerSixtyDays = 60 * 60 * 24 * 60;
    require(EXPIRATION - now <= secondsPerSixtyDays);
    queryOracle();                      // Schedule a call to oracle at contract expiration time.
}
```

`MarketContractOraclize` is the first fully implemented `MarketContract` that has been built out.  Using 
[Oraclize.it](http://www.oraclize.it/) allows for several different sources of truth in order to settle contracts.
More information on forming correct queries can 
be found in their [documentation](http://docs.oraclize.it/#ethereum-quick-start-simple-query).

[MPX](https://dapp.marketprotocol.io) additionally has some help in formatting your queries correctly
and a test environment to ensure the queries are correct prior to contract deployment.

### Additional parameters 

Parameter | Description
--------- |  -----------
oracleDataSource | a data-source such as "URL", "WolframAlpha", "IPFS" 
oracleQuery | properly formatted Oraclize.it query 


## Market Collateral Pool

> MarketCollateralPool constructor:

```javascript
/// @dev instantiates a collateral pool that is unique to the supplied address of a MarketContract. This pairing
/// is 1:1
/// @param marketContractAddress deployed address of a MarketContract
constructor(address marketContractAddress) Linkable(marketContractAddress) public {
    MKT_CONTRACT = MarketContract(marketContractAddress);
    MKT_TOKEN_ADDRESS = MKT_CONTRACT.MKT_TOKEN_ADDRESS();
}
```

The `MarketCollateralPool` is a contract controlled by a specific `MarketContract`.  It holds users balances, 
locked collateral balances and open positions accounting.  These balances and positions are unique to the linked 
`MarketContract` and a user must deposit funds for each `MarketContract` they intend to trade.  The ERC20 Token
specified are the only accepted form of funding or collateralization.


## Factory deployment
> MarketContractOraclize factory for deployment:

```javascript
/// @dev Deploys a new instance of a market contract and adds it to the whitelist.
/// @param contractName viewable name of this contract (BTC/ETH, LTC/ETH, etc)
/// @param collateralTokenAddress address of the ERC20 token that will be used for collateral and pricing
/// @param contractSpecs array of unsigned integers including:
/// floorPrice minimum tradeable price of this contract, contract enters settlement if breached
/// capPrice maximum tradeable price of this contract, contract enters settlement if breached
/// priceDecimalPlaces number of decimal places to convert our queried price from a floating point to
/// an integer
/// qtyMultiplier multiply traded qty by this value from base units of collateral token.
/// expirationTimeStamp - seconds from epoch that this contract expires and enters settlement
/// @param oracleDataSource a data-source such as "URL", "WolframAlpha", "IPFS"
/// see http://docs.oraclize.it/#ethereum-quick-start-simple-query
/// @param oracleQuery see http://docs.oraclize.it/#ethereum-quick-start-simple-query for examples
function deployMarketContractOraclize(
    string contractName,
    address collateralTokenAddress,
    uint[5] contractSpecs,
    string oracleDataSource,
    string oracleQuery
) external
{
    MarketContractOraclize mktContract = new MarketContractOraclize(
        contractName,
        msg.sender,
        MKT_TOKEN_ADDRESS,
        collateralTokenAddress,
        collateralPoolFactoryAddress,
        contractSpecs,
        oracleDataSource,
        oracleQuery
    );
    MarketContractRegistryInterface(marketContractRegistry).addAddressToWhiteList(mktContract);
    emit MarketContractCreated(address(mktContract));
}
```
> MarketCollateralPool factory for deployment:

```javascript
/// @dev creates the needed collateral pool and links it to our market contract.
/// @param marketContractAddress address of the newly deployed market contract.
function deployMarketCollateralPool(address marketContractAddress) external {
    require(MarketContractRegistryInterface(marketContractRegistry).isAddressWhiteListed(marketContractAddress));
    MarketCollateralPool marketCollateralPool = new MarketCollateralPool(marketContractAddress);
    MarketContract(marketContractAddress).setCollateralPoolContractAddress(marketCollateralPool);
}
```

Currently two factories exist to aid in the deployment of linked contracts and the whitelisting of these contracts in 
the [`MarketContractRegistry`](#market-contract-registry), which holds a record of all currently deployed and functional
contracts.

### MarketContractOraclize deployment

First, a user calls `deployMarketContractOraclize` on the `MarketContractFactoryOraclize` in order to begin
the deployment process.


This function call creates the new MarketContractOraclize and then adds the address to the `MarketContractRegistry` so
that others may find the contract for trading. A second call to the `deployMarketCollateralPool` of the 
`MarketCollateralPoolFactory` then deploys the needed `MarketCollateralPool` and links it to the `MarketContract`.
At this point the contract is ready to be traded.


 
## Collateral

### Depositing funds for trading

> depositTokensForTrading function

```javascript
/// @notice deposits tokens to the smart contract to fund the user account and provide needed tokens for collateral
/// pool upon trade matching.
/// @param depositAmount qty of ERC20 tokens to deposit to the smart contract to cover open orders and collateral
function depositTokensForTrading(uint256 depositAmount) external {
    // user must call approve!
    require(MarketToken(MKT_TOKEN_ADDRESS).isUserEnabledForContract(MKT_CONTRACT, msg.sender));
    uint256 balanceAfterDeposit = userAddressToAccountBalance[msg.sender].add(depositAmount);
    ERC20(MKT_CONTRACT.COLLATERAL_TOKEN_ADDRESS()).safeTransferFrom(msg.sender, this, depositAmount);
    userAddressToAccountBalance[msg.sender] = balanceAfterDeposit;
    emit UpdatedUserBalance(msg.sender, balanceAfterDeposit);
}
```

Funds deposited by a user are allocated to their address's account balance until a point at which a new position is 
opened and the funds then become allocated to `collateralPoolBalance` and are locked until the user exits their
position or the contract expires.  In this way, all open positions are always fully collateralized eliminating any
counter party risk and ensuring the solvency of the contract.

### Calculating needed collateral and maximum possible loss

> calculateNeededCollateral function

```javascript
/// @notice determines the amount of needed collateral for a given position (qty and price)
/// @param priceFloor lowest price the contract is allowed to trade before expiration
/// @param priceCap highest price the contract is allowed to trade before expiration
/// @param qtyMultiplier multiplier for qty from base units
/// @param qty signed integer corresponding to the traded quantity
/// @param price of the trade
function calculateNeededCollateral(
    uint priceFloor,
    uint priceCap,
    uint qtyMultiplier,
    int qty,
    uint price
) pure internal returns (uint neededCollateral)
{

    uint maxLoss;
    if (qty > 0) {   // this qty is long, calculate max loss from entry price to floor
        if (price <= priceFloor) {
            maxLoss = 0;
        } else {
            maxLoss = subtract(price, priceFloor);
        }
    } else { // this qty is short, calculate max loss from entry price to ceiling;
        if (price >= priceCap) {
            maxLoss = 0;
        } else {
            maxLoss = subtract(priceCap, price);
        }
    }
    neededCollateral = maxLoss * abs(qty) * qtyMultiplier;
}
``` 

The amount of funds that are allocated to the `collateralPoolBalance` upon entering a trade is defined by that positions
maximum possible loss.  

All positions are always fully collateralized, meaning the maximum possible loss for a position is the required 
amount of collateral to open that position. This can be calculated from the `price` and `qty` of the 
position and the defined specifications of the `MarketContract`.  

For a buyer, the maximum possible loss is calculated as the `price` of the 
trade minus the `priceFloor` times the qty transacted. Conversely, if you are opening a short position the maximum 
loss is calculated as `priceCap` minus the price of the trade, multiplied by the `qty` transacted. Upon filling an order 
both parties commit their respective maximum loss to the collateral pool.


Parameter | Description
--------- |  -----------
priceFloor | as defined in the `MarketContract` 
priceCap | as defined in the `MarketContract` 
qtyMultiplier | as defined in the `MarketContract`
qty | signed integer corresponding to the traded quantity
price | agreed upon execution price

### Withdrawing funds 

> withdrawTokens function

```javascript
/// @notice removes token from users trading account
/// @param withdrawAmount qty of token to attempt to withdraw
function withdrawTokens(uint256 withdrawAmount) public {
    //require(userAddressToAccountBalance[msg.sender] >= withdrawAmount);  subtract call below will enforce this
    uint256 balanceAfterWithdrawal = userAddressToAccountBalance[msg.sender].subtract(withdrawAmount);
    userAddressToAccountBalance[msg.sender] = balanceAfterWithdrawal;   // update balance before external call!
    ERC20(MKT_CONTRACT.COLLATERAL_TOKEN_ADDRESS()).safeTransfer(msg.sender, withdrawAmount);
    emit UpdatedUserBalance(msg.sender, balanceAfterWithdrawal);
}
```

At any time, tokens that are not allocated to an open position held by the user, are able to be withdrawn.

Upon exiting a position funds are returned to the user's account balance, net of any profit or loss.  Similarly,
if the contract expires with the user maintaining an open position, their position settles to the final settlement
price of the contract and funds are then eligible for immediate withdraw.
 
## Orders

> MARKET's Order struct

```javascript
struct Order {
    address maker;
    address taker;
    address feeRecipient;
    uint makerFee;
    uint takerFee;
    uint price;
    uint expirationTimeStamp;
    int qty;
    bytes32 orderHash;
}
```

> Generating and confirming Order signatures

```javascript
/// @notice creates the hash for the given order parameters.
/// @param contractAddress address of the calling contract, orders are unique to each contract
/// @param orderAddresses array of 3 address. maker, taker, and feeRecipient
/// @param unsignedOrderValues array of 5 unsigned integers. makerFee, takerFee, price, expirationTimeStamp and salt
/// @param orderQty signed qty of the original order.
function createOrderHash(
    address contractAddress,
    address[3] orderAddresses,
    uint[5] unsignedOrderValues,
    int orderQty
) public pure returns (bytes32)
{
    return keccak256(
        abi.encodePacked(
            contractAddress,
            orderAddresses[0],
            orderAddresses[1],
            orderAddresses[2],
            unsignedOrderValues[0],
            unsignedOrderValues[1],
            unsignedOrderValues[2],
            unsignedOrderValues[3],
            unsignedOrderValues[4],
            orderQty
        )
    );
}

/// @notice confirms hash originated from signer
/// @param signerAddress - address of order originator
/// @param hash - original order hash
/// @param v order signature
/// @param r order signature
/// @param s order signature
function isValidSignature(
    address signerAddress,
    bytes32 hash,
    uint8 v,
    bytes32 r,
    bytes32 s
) public pure returns (bool)
{
    return signerAddress == ecrecover(
        keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
        v,
        r,
        s
    );
}
```

MARKET utilizes off chain orders to reduce the number of needed transactions that must occur on the blockchain.   Third 
party Nodes will provide order book hosting and aggregation services on top of the protocol to facilitate liquidity.
Orders however are cryptographically signed to ensure no manipulation and facilitate trust-less executions.
 
Makers create orders and sign them (making liquidity), while takers select signed orders 
to trade against (taking liquidity).  

Parameter | Description
--------- |  -----------
maker | address of user who originated and signed this order 
taker | address of counter-party to fill order or `null` to allow any counter-party 
feeRecipient | address of fee recipient node, if any (MARKET does not charge any fees, but nodes may)
makerFee | fee to paid by the maker in MKT tokens to the `feeRecipient`
takerFee | fee to paid by the taker in MKT tokens to the `feeRecipient`
price | agreed upon execution price
expirationTimeStamp | timestamp that the order is valid until
qty | agreed upon execution qty
orderHash | hash created by maker to ensure all order parameters are valid and originated from `maker`

A maker creates an order with the specified parameters and calls `createOrderHash` that is transmitted 
along with the order.  Any part can verify the veracity of the hash with `isValidSignature` which will match the
signer's address if all parameters of the order are valid.

Makers may cancel an order at any time, unfortunately this transaction happens on chain and will require gas to complete.
Alternatively, an `Order` can be created with an `expirationTimeStamp` expiring the order automatically without the
additional gas cost. 

## Trading

```javascript
// @notice called by a participant wanting to trade a specific order
/// @param orderAddresses - maker, taker and feeRecipient addresses
/// @param unsignedOrderValues makerFee, takerFree, price, expirationTimeStamp, and salt (for hashing)
/// @param orderQty quantity of the order
/// @param qtyToFill quantity taker is willing to fill of original order(max)
/// @param v order signature
/// @param r order signature
/// @param s order signature
function tradeOrder(
    address[3] orderAddresses,
    uint[5] unsignedOrderValues,
    int orderQty,
    int qtyToFill,
    uint8 v,
    bytes32 r,
    bytes32 s
) external returns (int filledQty)
{
    require(isCollateralPoolContractLinked && !isSettled); // no trading past settlement
    require(orderQty != 0 && qtyToFill != 0 && orderQty.isSameSign(qtyToFill));   // no zero trades, sings match
    require(MKT_TOKEN.isUserEnabledForContract(this, msg.sender));
    OrderLib.Order memory order = address(this).createOrder(orderAddresses, unsignedOrderValues, orderQty);
    require(MKT_TOKEN.isUserEnabledForContract(this, order.maker));

    // taker can be anyone, or specifically the caller!
    require(order.taker == address(0) || order.taker == msg.sender);
    // do not allow self trade
    require(order.maker != address(0) && order.maker != msg.sender);
    require(
        order.maker.isValidSignature(
            order.orderHash,
            v,
            r,
            s
    ));


    if (now >= order.expirationTimeStamp) {
        emit Error(ErrorCodes.ORDER_EXPIRED, order.orderHash);
        return 0;
    }

    int remainingQty = orderQty.subtract(getQtyFilledOrCancelledFromOrder(order.orderHash));
    if (remainingQty == 0) { // there is no qty remaining  - cannot fill!
        emit Error(ErrorCodes.ORDER_DEAD, order.orderHash);
        return 0;
    }

    filledQty = MathLib.absMin(remainingQty, qtyToFill);
    marketCollateralPool.updatePositions(
        order.maker,
        msg.sender,
        filledQty,
        order.price
    );
    orderMappings.addFilledQtyToOrder(order.orderHash, filledQty);

    uint paidMakerFee = 0;
    uint paidTakerFee = 0;

    if (order.feeRecipient != address(0)) {
        // we need to transfer fees to recipient
        uint filledAbsQty = filledQty.abs();
        uint orderAbsQty = filledQty.abs();
        if (order.makerFee > 0) {
            paidMakerFee = order.makerFee.divideFractional(filledAbsQty, orderAbsQty);
            MKT_TOKEN.safeTransferFrom(
                order.maker,
                order.feeRecipient,
                paidMakerFee
            );
        }

        if (order.takerFee > 0) {
            paidTakerFee = order.takerFee.divideFractional(filledAbsQty, orderAbsQty);
            MKT_TOKEN.safeTransferFrom(
                msg.sender,
                order.feeRecipient,
                paidTakerFee
            );
        }
    }

    emit OrderFilled(
        order.maker,
        msg.sender,
        order.feeRecipient,
        filledQty,
        paidMakerFee,
        paidTakerFee,
        order.orderHash
    );

    return filledQty;
}
```

When a `taker` finds an order they would like to transact against, they call the `tradeOrder` function. 

This function, verifies the order signature, ensures all contracts and users are allowed to trade and if successful
handles the accounting with the associated resulting fills (either open a new position, or perhaps, closing out an 
existing open position). 

A `taker` is not required to fill the entire `maker` order and specifies the `qty` they are willing to transact.  The
price however is static as set and signed by the `maker`.

## Market Contract Registry

A registry will exist of all MARKET contracts that are approved for trading.  Eventually there will be some
mechanism for the community to flag contracts that are not valid, or reasonable for removal from the white list.  At
first this may be more centralized, but eventually the goal is to have a fully decentralized community in charge of 
such matters.

## MKT Tokens

![MKT Tokens](/images/MARKET_Protocol-MKT-small.png)


MKT Tokens are the lifeblood of the MARKET ecosystem.  All fees charged by nodes will be transacted in MKT and additionally
anyone who wishes to create a new `MarketContract` will be forced to have some minimum balance of MKT. Finally, for every
`MarketContract` a user desires to trade, some amount of MKT must be locked to enable access to that contract.  These
can be unlocked at any time the user wishes to stop trading that `MarketContract`.   
