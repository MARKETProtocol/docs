# Tutorial #1 - Orders

This tutorial will go over creating, validating and filling an order using our library MARKET.js.  This tutorial utilizes
a local development environment in which we have MARKET Protocol Smart Contracts deployed to and trading accounts created
that are already pre-funded with the needed tokens for trading.

## Installation

> Clone needed repos:
 
```shell

# 1. clone our demo-project
git clone https://github.com/MARKETProtocol/demo-projects.git

# 2. clone the ethereum-bridge to allow deployment of our contracts connect to Oraclize.it
git clone https://github.com/MARKETProtocol/ethereum-bridge.git

# 3. install needed dependencies
npm install -g truffle
cd ~/demo-projects
npm install
cd ~/ethereum-bridge
npm install

```

In order to simplify developers interaction with our underlying smart contracts and the ethereum
blockchain, we have created the MARKET.js library. It provides a standardized and simplified API to interact
with MARKET Protocol. In order to create a development environment, you will need to have
a local instance of the blockchain to interact with.  For this we recommend using [Truffle](https://truffleframework.com/)

We have also created a demo starter project to help with these tutorials available on [github](https://github.com/MARKETProtocol/demo-projects).
 
You can clone the repo locally to run the tutorial and being working with MARKET Protocol.  You will also need to clone
the `ethereum-bridge` which allows for our contracts to interact with Oraclize.it for demonstration purposes

## Development Environment

> Start truffle:

 ```shell
cd ~/demo-projects
truffle develop
```

> Start the ethereum bridge (in a separate console) :

```shell
cd ~/ethereum-bridge
node bridge -H localhost:9545 -a 9 --dev
```

> Deploy contracts to the local truffle instance

```shell
# inside truffle console, 
truffle(develop)> migrate --reset

```

After you have installed these projects and the needed dependencies, you can begin to create the needed development environment.

1. Start truffle
1. Start the ethereum bridge (in a separate console)
1. Once the ethereum bridge has initialized, you will see a log message similiar to `[2018-08-22T18:49:30.289Z] INFO Listening @ 0xf7e3e47e06f1bddecb1b2f3a7f60b6b25fd2e233 (Oraclize Connector)
` you can now run the migrations to deploy our contracts to the local truffle instance.

<aside class="notice">
If you see an error similiar to `Error: VM Exception while processing transaction: revert` the ethereum-bridge probably isn't intialized yet.
Check the logging output in that console, and attempt to rerun the migrations.
</aside>

If you have followed along this along, congratulations, you have a working local MARKET Protocol environment to work against. We can now 
move on to our tutorial. 

If you are unable to get the environment set up please come find us in [Discord](https://marketprotocol.io/discord), 
there are several core dev team members in #engineering that will be happy to help!

## Essential packages

> Import the needed packages:

```javascript

import * as Web3 from 'web3';
import { Constants, Market, MARKETProtocolConfig, Utils } from '@marketprotocol/marketjs';

```

There are a few essential packages for interacting with our protocol, and the ethereum blockchain. `Web3` provides
the needed functionality for us to connect with our local truffle node, and marketjs is our MARKET.js library
designed to simplify your interactions with the underlying MARKET Protocol Smart Contracts.

## Instantiation

> Creating a web3 instance and the Market object:

```javascript

const web3Instance = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'));
const config: MARKETProtocolConfig = {
  networkId: Constants.NETWORK_ID_TRUFFLE
};

const market: Market = new Market(web3Instance.currentProvider, config);
```

Once we have imported these packages, we can now create an instance of web3, connected to our local truffle node
as the provider.  Using this provider, we can create a new `Market` object, which is the main entry point for
all functionality contained in MARKET.js

## Contract Specifications

> Getting whitelisted addresses and contract specs:

```javascript

const marketContractAddress: string[] = await market.getAddressWhiteListAsync();
const demoContractAddress: string = marketContractAddress[0];
const contractMetaData = await market.getContractMetaDataAsync(demoContractAddress);

```

The `Market` class provide methods for getting the current collection of white listed MARKET Protocol Smart Contract
addresses and well as meta data bout those deployed contracts.  It is also important to note, that there is 
an off chain API that can provide this information to users who need higher level functionality such as queries.

## Collateral

> Approving collateral transfer and deposit to the smart contract:

```javascript

const traderA = web3Instance.eth.accounts[0];
const traderB = web3Instance.eth.accounts[1];

await market.approveCollateralDepositAsync(demoContractAddress, 1e25, {from: traderA});
await market.approveCollateralDepositAsync(demoContractAddress, 1e25, {from: traderB});

await market.depositCollateralAsync(demoContractAddress, 1e25, {from: traderA});
await market.depositCollateralAsync(demoContractAddress, 1e25, {from: traderB});

```

Each MARKET Protocol Smart Contract has a unique collateral pool.  In order to enable trading, a user must first
approve the transfer of funds (an ERC20 token, as defined by the contract) and then call the `depositCollateralAsync`
method.  This will allow for ERC20 tokens to be moved from a user's address to the smart contract for trading. 
Deposited funds, that have not been committed to a trade, may be withdrawn at any time by the user.  Upon executing a
trader, the users maximum loss will become locked into the collateral pool, and that amount is no longer able to be
withdrawn until the trade is exited, or the contract settled.

## Order Creation

> Creating a signed order:

```javascript

const orderExpirationTimeStamp = new BigNumber(Math.floor(Date.now() / 1000) + 60 * 60); // expires in 1 hour
const fees = new BigNumber(0);
const orderQty = new BigNumber(1);
const orderPrice = new BigNumber(7500000);
const feeRecipient = Constants.NULL_ADDRESS;
const signedOrder = await market.createSignedOrderAsync(
  demoContractAddress,
  orderExpirationTimeStamp,
  feeRecipient,
  traderA,
  fees,
  traderB,
  fees,
  orderQty,
  orderPrice,
  Utils.generatePseudoRandomSalt(),
  false
);

```

After collateral funds have been deposited, a user is able to create a valid order for trading.  This order is signed
by the user in order to ensure its origin.  Market.js provides several methods for validation of the order
that can be used in order for proper pruning of order books by exchanges.


## Filling an Order

> trading against a signed order:

```javascript

const orderTransactionInfo: OrderTransactionInfo =
    await market.tradeOrderAsync(signedOrder, orderQty, { from: traderB, gas: 400000 });

// we can now display the information about this filled transaction
console.log(orderTransactionInfo.txHash, await orderTransactionInfo.filledQtyAsync);
```

By calling `traderOrderAsync` against a validated `SignedOrder`, a user may fill all or a portion of an order.  In order to 
avoid wasting gas, by a call to `traderOrderAsync` that will ultimately fail, Market.js provides as much verification as 
is possible prior to a call to the on-chain transaction.

If the trade is successfully executed, both counter-parties (TraderA and TraderB) will have their collateral locked,
and a newly recorded open position.

## Open Positions

> Querying open positions:
 
 ```javascript
console.log('Trader A - Open Positions =');
console.log(await market.getUserPositionsAsync(demoContractAddress, traderA, true, true));

console.log('Trader B - Open Positions =');
console.log(await market.getUserPositionsAsync(demoContractAddress, traderB, true, true));
 ```

A trader's open positions are recorded onto the blockchain and can be accessed with the `getUserPositionsAsync` function.
Additional functionality is provided for sorting and consolidating the reporting of these positions.

## Remaining Balances

> Retrieving remaining balances:
 
 ```javascript
console.log('\n Trader A Collateral Balance Remaining =',
    (await market.getUserUnallocatedCollateralBalanceAsync(demoContractAddress, traderA)).toString());
console.log('\n Trader B Collateral Balance Remaining =',
    (await market.getUserUnallocatedCollateralBalanceAsync(demoContractAddress, traderB)).toString());
 ```
The remaining collateral that is available for trading in the smart contract can be accessed via a call to 
`getUserUnallocatedCollateralBalanceAsync`.
