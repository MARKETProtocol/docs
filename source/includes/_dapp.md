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

## Find Contracts

The [Find Contracts](https://dapp.marketprotocol.io/contract/find) screen allows for a reverse lookup
for MARKET Contracts using the ethereum address of the deployed contract.  Users can enter
a known address, if valid, the dApp will display the current specifications of the MARKET Contract
deployed to this address.

## Test Query 

## Simulated Exchange
