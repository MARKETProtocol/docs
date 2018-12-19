# FAQ - MPX

### How do I log in to MPX?
- If you do not have MetaMask installed, then [click here](https://metamask.io/) to learn more.
- If you already have MetaMask installed, then open MetaMask and switch to the Rinkeby Test Network.

### Is there a MPX mobile app or website?
The first version of MPX has been built to provide an optimal experience on desktops. We will deliver a mobile-friendly experience in a future release.

### How do I deposit funds to begin trading?
To begin trading, you will need Rinkeby testnet ETH (which is not real ETH) and also collateral (which is simulated and has no financial value). First, get testnet ETH from the [Rinkeby Ether Faucet](https://faucet.rinkeby.io/), then request collateral within MPX. Next, you will need to transfer collateral from your MetaMask wallet to MPX. For more detailed instructions, please view our walkthrough [here](https://youtu.be/FrPh1H8tRsQ).

### What contracts are available to trade on MPX?
During our beta we are supporting the following contracts:
- ETH/USD
- BTC/USD
- S&P 500/USD
- AAPL/USD
- GOLD/USD
- OIL/USD

### What are the components that make up a contract?
- Reference asset
- Price cap & floor
- Price oracle
- Collateral token
- Expiration date & time

### How do I read a contract’s name?
Example: BTC_USD_BIN_1546293599_BETA
- BTC - Reference asset
- USD - Collateral token
- BIN - Price oracle
- 1546293599 - Expiration [UNIX timestamp](https://en.wikipedia.org/wiki/Unix_time)
- BETA - Custom name defined by the contract’s creator

### How do I know when a contract expires?
At the top of MPX, you will see the current selected contract. To the far right of the contract, you can view the expiration of that contract, as in the image below. The expiration of a contract can also be viewed in the contract explorer by searching for the contract.
<img src="https://github.com/MARKETProtocol/docs/blob/master/source/images/exchange-navbar.png?raw=true" align="middle">

### How do I view the price floor and cap of a contract?
At the top of MPX, you will see the current selected contract. To the right of the contract, you will see the price floor and cap of that contract, as in the image above. The price bounds of a contract can also be viewed in the contract explorer by searching for the contract.

### How do I deploy a contract?
Currently there is a limited set of deployed MARKET Protocol contracts available for trading. In the future, we will offer many more contracts. We’d love to [hear from you](https://docs.google.com/forms/d/e/1FAIpQLSf6llO6BsU6jkZrfv-sOePxxZf8wJ4AxHGBl4mRBrlALe2z9g/viewform) what assets you want to trade!

### What is an order book?
An order book is a ledger containing all outstanding orders – inputs from traders looking to buy or sell something. An order to buy is called a ‘bid’ and an order to sell is called an ‘ask.’

### How do I fill an order?
To fill an order in the order book, you select the order, choose the quantity you would like to trade, and then confirm the transaction through MetaMask.

### How do I create an order?
To create an order, you select whether your order is to buy or sell, choose the quantity, input the expiration date and time, and then sign the order through MetaMask. Creating an order does not require an on-chain transaction or a transaction fee.

### How do I know if my transaction was successful?
When you create or fill an order, you will receive a notification containing the transaction hash and a link to [Etherscan](https://etherscan.io/) where you can view your transaction.

### How do I adjust the gas price for transactions?
MPX currently runs on the Rinkeby testnet where ether and gas have no actual financial value, so for now the gas price is not an issue.

### Where can I view my pending orders?
You can view your pending on the Open Orders tab in MPX.

### Where can I view my completed trades?
You can view your completed trades on the Fills tab in MPX.

### Where can I view my current positions?
You can view your current positions on the Positions tab in MPX.

### How do I know when a contract that I’m trading has expired?
You can view your positions and see if they have expired by navigating to the Positions tab in MPX. In the future, you will be able to set up personalized notifications.

### Is there be a minimum amount required to make a trade?
No, there is no minimum required trade amount.

### Does MPX support margin trading?
No, margin trading is not currently supported.

### Do MARKET Protocol contracts have leverage?
Yes, MARKET Protocol contracts have inherent leverage because of the way they are structured. In order to trade, you will lock your maximum downside in a smart contract. This amount is the difference between your order price and the price cap or floor of the contract you are trading. As a result, you are using less collateral than if you were to trade the full price of the underlying reference asset, and this provides you with leverage.

### How much collateral is required to make a trade?
The required amount of collateral for your order will be automatically calculated when you select a quantity and price.

### What is the difference between a maker and a taker?
A maker is a trader creating a new buy or sell order, while a taker is a trader filling an existing order. Maker’s create or ‘make’ liquidity, while takers take that liquidity.

### What is the difference between a long and short position?
A trader that takes a long position in a contract profits from an increase in the price of the contract’s reference asset, while a trader taking a short position profits from a decline in the price.


