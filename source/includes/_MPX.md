# MPX

The MARKET Protocol decentralized exchange (MPX) provides a simulated trading environment that allows user to place 
test trades and participate in beta releases of the protocol.

MPX is currently running on the `Rinkeby testnet` [here](https://mpexchange.io/).

## Using an Ethereum-enabled browser

For testing and interacting with MPX, you will need to use a browser that supports Web3. 
We recommend using the [Metamask Chrome Browser Extension](https://metamask.io/). This will enable you to connect to the 
Ethereum network from your browser. Metamask allows you to run Ethereum dApps right in your browser without running a full Ethereum node.

## Acquire Test ETH

Our smart contracts are currently deployed on the `Rinkeby testnet`. You will need to have test ETH to use this library. 
You can request test funds from the [Rinkeby faucet](https://faucet.rinkeby.io/). 

<aside class="notice">
Always confirm that you are on Rinkeby testnet when testing the MPX.
</aside>

## Exchange
Experience the power of blockchain derivatives trading with [MPX](https://mpexchange.io), our decentralized exchange (DEX) built on top of MARKET Protocol.

## Contract Deployment

MARKET Protocol creates a flexible contract specification which allows users to easily implement
their desired contract prior to trading.  First time users, can use our 
[Simplified Deploy](https://mpexchange.io/contract/deploy?mode=simplified) process
walking them through the step by step process to deployment. 

<!--

### Simplified Deploy

MARKET Protocol Guided Deploy provides a step by step guide to first time deployment.  Below are the needed variables
to deploy a contract to the Ethereum Blockchain

1. `Name` - the contract name should be as descriptive as possible capturing the underlying asset relationship as well as possibly the expiration. 
   Something like `ETH/BTC-Kraken_YYYY-MM-DD` may help others understand the underlying asset, the data source, and 
   expiration date in a nice human readable and searchable way.
   In the future, MARKET will implement a standardized naming convention and guidelines to formalize this process
2. `Collateral Token` - every contract should be backed by an ERC20 Token that will be used a collateral for the contract. Traders 
   must deposit tokens to the smart contract prior to trading, and upon execution of a trade, the appropriate amount of 
   collateral becomes locked until that position is exited. In this fashion, all open positions always remain 100% 
   collateralized removing counter party risk from the traders. Please specify a ERC20 Token address for this contract.
   In the future, users will be able to easily select from well known ERC20 tokens to ensure more safety and 
   avoid dealing with long addresses.
3. `Oraclize.it data source` - Oraclize.it offers several data-sources such as "URL" and "WolframAlpha"
4. `Price Decimal Places` - Ethereum currently does not support floating points numbers. Therefore all prices reported by 
   oracles must be converted to a whole number (integer). This variable is how many decimal places one needs to move 
   the decimal in order to go from the oracle query price to an integer. For example, if the oracle query results 
   returned a value of 190.22, we need to move the decimal two (2) places to convert to a whole number of 19022, 
   so we would enter 2. 
5. `Price Floor` - this is the lower bound of price exposure this contract will trade. If the oracle reports a price 
   below this value the contract will enter into settlement. This should also be represented as a whole number. 
   If we take the example above of a price of 190.22 and decide the Floor for our contract should be 150.00, 
   we would enter 15000.
6. `Price Cap` - This is the upper bound of price exposure this contract will trade. If the oracle reports a price above this value 
   the contract will enter into settlement. Following our example, if we decide the Cap for our contract 
   should be 230.00, we would enter 23000 as our Cap.  
7. `Qty Multiplier` - The quantity multiplier allows the user to specify how many base units (for Ethereum, this would be wei) each integer 
   price movement changes the value of the contract. If our integerized price was 19022 with a qty multiplier of 1, 
   and the price moved to 19023, then the value will have change by 1 wei. If however the multiplier was set at 
   1,000,000,000 the price movement of 1 unit would now correspond to a value of 1 gwei (not wei). 
   Please see [here](https://etherconverter.online/) for an ethereum unit converter.
8. `Expiration Time` - upon reaching the expiration timestamp all open positions will settle against the final 
   price query returned by the oracle.

   
### Quick Deploy

MARKET Protocol Quick Deploy provides a scaled down interface for easy deployment of contracts to the 
Ethereum blockchain.  Expert users can enter variables, that are validated with error checking prior
to deploying.

Parameter | Description
--------- |  -----------
Name | Viewable name of this contract, in the future we will implement suggested naming conventions 
Collateral Token Address | address of the ERC20 token that will be used for collateral
Price Floor | minimum tradeable price of this contract
Price Cap | maximum tradeable price of this contract
Price Decimal Places | Since all numbers must be represented as integers on the Ethereum blockchain, this is how many decimal places one needs to move the decimal in order to go from the oracle query price to an integer. For instance if the oracle query results returned a value such as 190.22, we need to move the decimal two (2) places to convert to an integer value of 19022.
Qty Multiplier | The qty multiplier allows the user to specify how many base units (for ethereum, this would be wei) each integer price movement changes the value of the contract. If our integerized price was 19022 with a qty multiplier of 1, and the price moved to 19023, then the value will have change by 1 wei. If however the multiplier was set at 1,000,000,000 the price movement of 1 unit would now correspond to a value of 1 gwei (not wei)
Expiration Time |  Expiration timestamp for all open positions to settle.
Oraclize.it data source |  Available data sources from Oraclize.it
Oraclize.it Query |  Properly structured Oraclize.it query, please use the [test query](http://mpexchange.io/test) page for clarification
-->


## Explore Contracts

MARKET Protocol's dApp, MPX, provides the needed functionality to easily search, filter, and sort already deployed
MARKET Smart Contracts.  
