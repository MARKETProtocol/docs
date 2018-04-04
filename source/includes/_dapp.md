# dApp

The MARKET Protocol dApp provides tools for contract creation, oracle testing and deployment. 
Additionally, users are able to easily search previously deployed MARKET contracts they would 
like to trade.

A simulated trading environment allows user to place test trades and participate in beta
releases of the protocol.

## Contract Deployment

MARKET Protocol creates a flexible contract specification which allows users to easily implement
their desired contract prior to trading.  First time users, can use our 
[Guided Deploy](https://dapp.marketprotocol.io/contract/deploy?mode=guided) process
walking them through the step by step process to deployment.  Expert users, can opt for a more
condensed process with the [Quick Deploy](https://dapp.marketprotocol.io/contract/deploy?mode=quick) 

### Guided Deploy

MARKET Protocol Quick Deploy provides a step by step guide to first time deployment.  Below are the needed variables
to deploy a contract to the Ethereum Blockchain

1. Name - the contract name should be as descriptive as possible capturing the underlying asset relationship as well as possibly the expiration. 
   Something like `ETH/BTC-Kraken_YYYY-MM-DD` may help others understand the underlying asset, the data source, and 
   expiration date in a nice human readable and searchable way.
   In the future, MARKET will implement a standardized naming convention and guidelines to formalize this process
2. Base Token - every contract should be backed by an ERC20 Token that will be used a collateral for the contract. Traders 
   must deposit tokens to the smart contract prior to trading, and upon execution of a trade, the appropriate amount of 
   collateral becomes locked until that position is exited. In this fashion, all open positions always remain 100% 
   collateralized removing counter party risk from the traders. Please specify a ERC20 Token address for this contract.
   In the future, users will be able to easily select from well known ERC20 tokens to ensure more safety and 
   avoid dealing with long addresses.
3. Oraclize.it data source - Oraclize.it offers several data-sources such as "URL", "WolframAlpha" and "IPFS"
4. Price Decimal Places - Ethereum currently does not support floating points numbers. Therefore all prices reported by 
   oracles must be converted to a whole number (integer). This variable is how many decimal places one needs to move 
   the decimal in order to go from the oracle query price to an integer. For example, if the oracle query results 
   returned a value of 190.22, we need to move the decimal two (2) places to convert to a whole number of 19022, 
   so we would enter 2. 
5. Price Floor - this is the lower bound of price exposure this contract will trade. If the oracle reports a price 
   below this value the contract will enter into settlement. This should also be represented as a whole number. 
   If we take the example above of a price of 190.22 and decide the Floor for our contract should be 150.00, 
   we would enter 15000.
6. This is the upper bound of price exposure this contract will trade. If the oracle reports a price above this value 
   the contract will enter into settlement. Following our example, if we decide the Cap for our contract 
   should be 230.00, we would enter 23000 as our Cap.  
7. The quantity multiplier allows the user to specify how many base units (for Ethereum, this would be wei) each integer 
   price movement changes the value of the contract. If our integerized price was 19022 with a qty multiplier of 1, 
   and the price moved to 19023, then the value will have change by 1 wei. If however the multiplier was set at 
   1,000,000,000 the price movement of 1 unit would now correspond to a value of 1 gwei (not wei). 
   Please see [here](https://etherconverter.online/) for an ethereum unit converter.
8. Expiration Time - upon reaching the expiration timestamp all open positions will settle against the final 
   price query returned by the oracle.

   
### Quick Deploy

MARKET Protocol Quick Deploy provides a scaled down interface for easy deployment of contracts to the 
Ethereum blockchain.  Expert users can enter variables, that are validated with error checking prior
to deploying.

Parameter | Description
--------- |  -----------
Name | Viewable name of this contract, in the future we will implement suggested naming conventions 
Base Token Address | address of the ERC20 token that will be used for collateral
Price Floor | minimum tradeable price of this contract
Price Cap | maximum tradeable price of this contract
Price Decimal Places | Since all numbers must be represented as integers on the Ethereum blockchain, this is how many decimal places one needs to move the decimal in order to go from the oracle query price to an integer. For instance if the oracle query results returned a value such as 190.22, we need to move the decimal two (2) places to convert to an integer value of 19022.
Qty Multiplier | The qty multiplier allows the user to specify how many base units (for ethereum, this would be wei) each integer price movement changes the value of the contract. If our integerized price was 19022 with a qty multiplier of 1, and the price moved to 19023, then the value will have change by 1 wei. If however the multiplier was set at 1,000,000,000 the price movement of 1 unit would now correspond to a value of 1 gwei (not wei)
Expiration Time |  Expiration timestamp for all open positions to settle.
Oraclize.it data source |  Available data sources from Oraclize.it
Oraclize.it Query |  Properly structured Oraclize.it query, please use the [test query](http://dapp.marketprotocol.io/test) page for clarification


## Explore Contracts

MARKET Protocol's dApp provides the needed functionality to easily search, filter, and sort already deployed
MARKET Smart Contracts.  

## Find Contracts

The [Find Contracts](https://dapp.marketprotocol.io/contract/find) screen allows for a reverse lookup
for MARKET Contracts using the ethereum address of the deployed contract.  Users can enter
a known address, if valid, the dApp will display the current specifications of the MARKET Contract
deployed to this address.

## Test Query 

## Simulated Exchange

Coming soon...
