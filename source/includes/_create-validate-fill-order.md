# Tutorial - Orders

This tutorial will go over creating, validating and filling an order using our library MARKET.js

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

In order to simplify app developers interaction with our underlying smart contracts and the ethereum
blockchain, we have create the MARKET.js library to provide a standardized and simplified API to interact
with the underlying MARKET Protocol.  In order to create a development environment, you will need to create
a local instance of the blockchain to interact with.  For this we recommend using [Truffle](https://truffleframework.com/)

We have also created a demo starter project to help with these tutorials available on [github](https://github.com/MARKETProtocol/demo-projects).
 
You can clone the repo locally to run the tutorial and being working with MARKET Protocol.  You will also need to clone
the `ethereum-bridge` which allows for our contracts to interact with Oraclize.it for demonstration purposes


## Setting up the develop environment

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

If your struggling
to get the environment set up please come find us in [Discord](https://marketprotocol.io/discord), there are several
core dev team members in #engineering that will be happy to help!

## Essential packages

> Import the needed packages:

```javascript

import * as Web3 from 'web3';
import { Market, MARKETProtocolConfig, Utils } from '@marketprotocol/marketjs';

```

There are a few essential packages for interacting with our protocol, and the ethereum blockchain. `Web3` provides
the needed functionality for us to connect with our local truffle node, and marketjs is our MARKET.js library
designed to simplify your interactions with the underlying MARKET Protocol Smart Contracts.

## Instantiation

> Creating a web3 instance and the Market object:

```javascript

const web3Instance = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'));
const config: MARKETProtocolConfig = {
    networkId: TRUFFLE_NETWORK_ID
};

const market: Market = new Market(web3Instance.currentProvider, config);

```

Once we have imported these packages, we can now create an instance of web3, connected to our local truffle node
as the provider.  Using this provider, we can create a new `Market` object, which is the main entry point for
all functionality contained in MARKET.js

