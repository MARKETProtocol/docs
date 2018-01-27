# Solidity Smart Contracts

All code for our smart contracts can be found [here](https://github.com/MarketProject/MarketProtocol). If you have any
issues to report please do so by opening an issue on [GitHub](https://github.com/MarketProject/MarketProtocol/issues).

## Market Contract

> MarketContract constructor:

```javascript
    /// @param contractName viewable name of this contract (BTC/ETH, LTC/ETH, etc)
    /// @param marketTokenAddress address of our member token
    /// @param baseTokenAddress address of the ERC20 token that will be used for collateral and pricing
    /// @param contractSpecs array of unsigned integers including:
    /// floorPrice minimum tradeable price of this contract, contract enters settlement if breached
    /// capPrice maximum tradeable price of this contract, contract enters settlement if breached
    /// priceDecimalPlaces number of decimal places to convert our queried price from a floating point to
    /// an integer
    /// qtyDecimalPlaces decimal places to multiply traded qty by.
    /// expirationTimeStamp - seconds from epoch that this contract expires and enters settlement
    function MarketContract(
        string contractName,
        address marketTokenAddress,
        address baseTokenAddress,
        uint[5] contractSpecs
    ) public payable
    {
        MKT_TOKEN_ADDRESS = marketTokenAddress;
        MKT_TOKEN = MarketToken(marketTokenAddress);
        require(MKT_TOKEN.isBalanceSufficientForContractCreation(msg.sender));    // creator must be MKT holder
        PRICE_FLOOR = contractSpecs[0];
        PRICE_CAP = contractSpecs[1];
        require(PRICE_CAP > PRICE_FLOOR);

        PRICE_DECIMAL_PLACES = contractSpecs[2];
        QTY_DECIMAL_PLACES = contractSpecs[3];
        EXPIRATION = contractSpecs[4];
        require(EXPIRATION > now);

        CONTRACT_NAME = contractName;
        BASE_TOKEN_ADDRESS = baseTokenAddress;
        BASE_TOKEN = ERC20(baseTokenAddress);
    }
```

The `MarketContract` represents the main contract responsible for 
combining needed functionality for trading, settlement and position management.  Each `MarketContract` 
must be paired with a unique `MarketCollateralPool` ([see below](#collateral-pool)) after instantiation in order to allow trading to become
enabled.  

`MarketContract` is an abstract contract that will allow for implementing 
classes such as `MarketContractOraclize` to complete the needed top level functionality around oracle solutions.
We intend to expand our offering of oracle solutions offered in the near future.  If there are oracle services that
you would like to submit for possible inclusion in these future plans, please [contact](mailto:info@marketprotocol.io) us

### Oracle Pre-Funding

The `Creator` of the `MarketContract` must pre-fund the contract with enough ETH in order to pay for the gas costs
associated with future oracle queries.  We intend to provide tools to help with this process, and in addition any
unused, pre-funded ETH can be reclaimed by the `Creator` upon contract expiration.

<aside class="notice">
After linking of the <code>MarketContract</code> and the <code>MarketCollateralPool</code> is completed, the contract also must be added to 
the <code>MarketContractRegistry</code> in order to be fully functional for trading.
</aside>

Parameter | Description
--------- |  -----------
contractName | viewable name of this contract, in the future we will implement suggested naming conventions 
marketTokenAddress | address of the MKT deployed ERC20 token
baseTokenAddress | address of the ERC20 token that will be used for collateral
contractSpecs | array of unsigned integers including the below parameters
floorPrice | minimum tradeable price of this contract
capPrice | maximum tradeable price of this contract
expirationTimeStamp |  seconds from epoch that this contract expires and enters settlement


## Market Contract Oraclize

> MarketContractOraclize constructor:

```javascript
    /// @param contractName viewable name of this contract (BTC/ETH, LTC/ETH, etc)
    /// @param marketTokenAddress address of our member token
    /// @param baseTokenAddress address of the ERC20 token that will be used for collateral and pricing
    /// @param contractSpecs array of unsigned integers including:
    /// floorPrice minimum tradeable price of this contract, contract enters settlement if breached
    /// capPrice maximum tradeable price of this contract, contract enters settlement if breached
    /// priceDecimalPlaces number of decimal places to convert our queried price from a floating point to
    /// an integer
    /// qtyDecimalPlaces decimal places to multiply traded qty by.
    /// expirationTimeStamp - seconds from epoch that this contract expires and enters settlement
    /// @param oracleDataSource a data-source such as "URL", "WolframAlpha", "IPFS"
    /// see http://docs.oraclize.it/#ethereum-quick-start-simple-query
    /// @param oracleQuery see http://docs.oraclize.it/#ethereum-quick-start-simple-query for examples
    /// @param oracleQueryRepeatSeconds how often to repeat this callback to check for settlement, more frequent
    /// queries require more gas and may not be needed.
    function MarketContractOraclize(
        string contractName,
        address marketTokenAddress,
        address baseTokenAddress,
        uint[5] contractSpecs,
        string oracleDataSource,
        string oracleQuery,
        uint oracleQueryRepeatSeconds
    ) MarketContract(
        contractName,
        marketTokenAddress,
        baseTokenAddress,
        contractSpecs
    )  public payable
    {
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        ORACLE_DATA_SOURCE = oracleDataSource;
        ORACLE_QUERY = oracleQuery;
        ORACLE_QUERY_REPEAT = oracleQueryRepeatSeconds;
        require(checkSufficientStartingBalance(EXPIRATION.subtract(now)));
        queryOracle();  // schedules recursive calls to oracle
    }
```

`MarketContractOraclize` is the first fully implemented `MarketContract` that has been built out.  Using 
[Oraclize.it](http://www.oraclize.it/) allows for several different sources of truth in order to settle contracts.
More information on forming correct queries can 
be found in their [documentation](http://docs.oraclize.it/#ethereum-quick-start-simple-query).

Our [DApp](https://app.marketprotocol.io) additionally has some help in formatting your queries correctly
and a test environment to ensure the queries are correct prior to contract deployment.

### Additional parameters 

Parameter | Description
--------- |  -----------
oracleDataSource | a data-source such as "URL", "WolframAlpha", "IPFS" 
oracleQuery | properly formatted Oraclize.it query 
oracleQueryRepeatSeconds | how often to repeat the query and check for settlement, more frequent calling requires more pre-funding


## Market Collateral Pool

> MarketCollateralPool constructor:

```javascript
    /// @dev instantiates a collateral pool that is unique to the supplied address of a MarketContract. This pairing
    /// is 1:1
    /// @param marketContractAddress deployed address of a MarketContract
    function MarketCollateralPool(address marketContractAddress) Linkable(marketContractAddress) public {
        MKT_CONTRACT = MarketContract(marketContractAddress);
        MKT_TOKEN_ADDRESS = MKT_CONTRACT.MKT_TOKEN_ADDRESS();
        MKT_TOKEN = MarketToken(MKT_TOKEN_ADDRESS);
    }
```

The `MarketCollateralPool` is a contract controlled by a specific `MarketContract`.  It holds users balances, 
locked collateral balances and open positions accounting.  These balances and positions are unique the linked 
`MarketContract` and a user must deposit funds for each `MarketContract` they intend to trade.  The ERC20 Token
specified are the only accepted form of funding or collateralization.

### Depositing funds for trading

> depositTokensForTrading function

```javascript
    /// @notice deposits tokens to the smart contract to fund the user account and provide needed tokens for collateral
    /// pool upon trade matching.
    /// @param depositAmount qty of ERC20 tokens to deposit to the smart contract to cover open orders and collateral
    function depositTokensForTrading(uint256 depositAmount) external {
        // user must call approve!
        require(MKT_TOKEN.isUserEnabledForContract(MKT_CONTRACT, msg.sender));
        uint256 balanceAfterDeposit = userAddressToAccountBalance[msg.sender].add(depositAmount);
        ERC20(MKT_CONTRACT.BASE_TOKEN_ADDRESS()).safeTransferFrom(msg.sender, this, depositAmount);
        userAddressToAccountBalance[msg.sender] = balanceAfterDeposit;
        UpdatedUserBalance(msg.sender, balanceAfterDeposit);
    }
```

Funds deposited by a user a allocated to there address's account balance until a point at which a new position is 
opened and the funds then become allocated to `collateralPoolBalance` and are locked until the user exits their
position or the contract expires.  In this way, all open positions are always fully collateralized eliminating any
counter party risk and ensuring the solvency of the contract.

### Calculating needed collateral and maximum possible loss

> calculateNeededCollateral function

```javascript
    /// @notice determines the amount of needed collateral for a given position (qty and price)
    /// @param priceFloor lowest price the contract is allowed to trade before expiration
    /// @param priceCap highest price the contract is allowed to trade before expiration
    /// @param qtyDecimalPlaces number of decimal places in traded quantity.
    /// @param qty signed integer corresponding to the traded quantity
    /// @param price of the trade
    function calculateNeededCollateral(
        uint priceFloor,
        uint priceCap,
        uint qtyDecimalPlaces,
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
        neededCollateral = maxLoss * abs(qty) * qtyDecimalPlaces;
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
qtyDecimalPlaces | as defined in the `MarketContract`
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
        ERC20(MKT_CONTRACT.BASE_TOKEN_ADDRESS()).safeTransfer(msg.sender, withdrawAmount);
        UpdatedUserBalance(msg.sender, balanceAfterWithdrawal);
    }
```

At any time, tokens that are not allocated to an open position held by the user, are able to withdrawn.

Upon exiting a position funds are returned to the user's account balance, net of any profit or loss.  Similarly,
if the contract expires with the user maintaining an open position, their position settles to the final settlement
price of the contract and funds are then eligible for immediate withdraw.
 

## Market Contract Registry

Registry containing all currently tradeable MARKET contracts


## MKT Tokens

Currency driving the protocol
