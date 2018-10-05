# FAQ - General

## What blockchain is used?
MARKET Protocol has chosen to build on top of Ethereum.
## What is the token name?
MARKET Protocol Token
## What is the token ticker symbol?
MKT
## How can I receive updates from MARKET Protocol?
Check out our [telegram room](htttps://marketprotocol.io/telegram) and join our [newsletter!](https://marketprotocol.io/#subscribe) 
## What's the total supply of the token?
600 million MKT tokens (600,000,000) 
## Can extra MKT Tokens be added to the total supply?
No, there is a fixed supply.
## Can you mine the tokens?	
No.  All tokens will be minted upon main net launch.
## What wallet should I use to keep my MKT tokens?
MKT is an ERC20 token, so a wallet that supports ERC20 tokens will be needed.
## When will the main net launch occur?
The proposed launch date is in Q1 2019 
## What are the official chat channels and links?
* Main Site [https://marketprotocol.io](https://marketprotocol.io)
* Medium [https://medium.com/market-protocol](https://medium.com/market-protocol)
* GitHub [https://github.com/MARKETProtocol](https://github.com/MARKETProtocol)
* Telegram [https://t.me/Market_Protocol_Chat](https://t.me/Market_Protocol_Chat)
* Discord [https://marketprotocol.io/discord](https://marketprotocol.io/discord)

## I don't understand how qty's work in your contracts, can you explain?
Yes! The first thing to understand is that all numbers used in the ethereum blockchain must be integers (whole numbers)
and not floating point (decimals).  Therefore, all prices and qtys need to be represented on the backend as such.  Each
contract then defines a `Qty Multplier` that in turn determines exposure (and therefore collateral) per unit.  To help
understand this, lets go through a few examples.    


### Contract 1.  ETH vs DAI

`Price Cap - 31476` 

`Price Floor - 10492`
 
`Price Decimal Places - 2`
 
`Qty Multiplier - 1e16` 

In the above contract, we are using the stable coin Dai which has 18 decimal places to trade the price of ETH. 
The contract is created in such a way, that the smallest increment price movement of 1, from say 27585 to 27586 is worth
.01 of Dai, or in base units of Dai 1e+16.  In other words, every penny of price movement in ETH is worth a penny
in Dai.

This contract could be created in other ways as well.  For instance, maybe a contract with much larger exposure is
desired, we can increase the Qty Multiplier to achieve a contract where every penny of price movement in ETH is worth
1 dollar of Dai.    

### Contract 2.  ETH vs DAI X 100

`Price Cap - 31476`

`Price Floor - 10492`

`Price Decimal Places - 2`

`Qty Multiplier - 1e18`

In Contract 2, each integer price movement is equivalent to 1e+18 Dai, or a whole Dai / dollar.  End users could theoretically
achieve the same position in either contract by trading larger.  For instance, 100 units of Contract 1 would be equal exposure
to a single unit of Contract 2.   


