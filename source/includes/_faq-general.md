# FAQ - General

### What is a derivative?
A derivative represents a contract between a buyer and a seller. The value is derived from on an underlying asset or assets. Common derivatives use stocks, commodities, currencies, bonds, or interest rates as the underlying asset for the contract.
### Are you a decentralized exchange?
No, MARKET is a protocol to enable the trading of decentralized derivative like contracts.  Third parties will write the application layers on top of the protocol and we hope to create an API layer to facilitate this as well. 
### Who will host MARKET's order books?
Third party order book hosts, called nodes will be provided with an API that easy allows them to host an order book.  Nodes, in turn may charge fees for the services they provide.  These fee's are not determined by MARKET and are set directly by the node.
### Does MARKET charge a fee to use the protocol?
MARKET doesn't charge any fees.  Nodes however may set a fee for their services of hosting order books.
### How is the needed collateral for an open position calculated?
All positions are always fully collateralized, meaning the maximum possible loss for a position is the required amount of collateral to open that position. For a buyer, the maximum possible loss is calculated as the price of the trade minus the `PRICE_FLOOR` times the qty transacted.  Conversely, if you are opening a short position the maximum loss is calculated as `PRICE_CAP` minus the price of the trade, multiplied by the qty transacted.  Upon filling an order both parties commit their respective maximum loss to the collateral pool.
### If I want to open a short position do I need to borrow the asset?
No, there is no borrowing, fees to be paid, or locates to deal with for shorting.  Due to the unique nature of our derivative like contracts, a trader is able to open a short position without owning the underlying asset.  This is similar to how financial futures work, where a seller of the SP500 futures, doesn't need to own, locate, or borrow the SP500 in order to gain the short price exposure to the SP500.
### When is my collateral returned to me and able to be withdrawn?
Collateral is credited to a users address and able to be withdrawn upon expiration of the contract or if the user trades out of their open position.  For instance, if a trader holding a long open position, sells to close out that position prior to expiration, they will immediately be able to withdraw the collateral associated (plus or minus any profit or loss) with their trade.
### What happens if I hold an open position through contract expiration?
Upon expiration, the contract will reach a settlement price via the agreed upon oracle solution.  At this point, all funds will be able to be withdrawn for all open positions.  The amount of collateral that is credited back to the user will be determined by their execution price and the settlement price of the contract.  Note, that there will probably be some short delay between contract expiration and the settlement period to allow for disputes to be raised.
### When I trade out of an open position, how is my profit or loss allocated?
When a position is closed, the appropriate amount of funds are allocated back to the user and are immediately available for withdrawal from the smart contract.  If the trade that was made was profitable, more funds will be available for withdrawal than originally posted, and if the trade represented a loser for the user, less funds than originally posted would now be available for withdrawal.  As an example, let us imagine a contract with a `PRICE_FLOOR` of 50 and a `PRICE_CAP` of 150 using Token A as collateral.  Bob enters into a long position for a qty of 1 at a price of 85.  At this point 35 units of Token A would be committed to the collateral pool (representing his max possible loss).  Later, Bob exits his position by selling at a price of 95.  The amount of Token A now allocated to Bob's account is 45 (35 of which is his original collateral and 10 of which represents his profit from his trade) and is now able to be withdrawn from the smart contract if Bob so wishes. 
### Can a contract be created based on a different blockchain or off chain asset?
Yes, by using oracle solutions for settlement users can create contracts for any type of real world asset such as the SP500, or cross chain asset prices like Bitcoin or Monero. This opens endless opportunities and diversification for the holders of ERC20 tokens who do not want to convert into fiat but want to gain market exposure to non digital or cross chain assets.  
### Do you have a white paper available?
 Yes! Please select a language below
 
* [English Version](https://www.marketprotocol.io/assets/MARKET_Protocol-Whitepaper.pdf)
* [Chinese Version](https://www.marketprotocol.io/assets/MARKET_Protocol-Whitepaper-Chinese.pdf)  
 
### How will disputes be resolved?
 This is an area of active research and discussion.  We would love for community feedback to help shape the process.  Our current working theory is that once a contract settlement enters into a disputed state, that a second attempt may be made to use the originally agreed upon oracle, and if that still fails to enter into a crowd sourced voting from community members that are incentivized for a fair resolution.  We do anticipate that even in the best of circumstances oracle solutions will fail, or receive bad data.  The problem of bad or inaccurate market data is not new or unique in the world of finance, but the need to resolve these problems when they arise in a trust-less manner will be essential. 
### How do I get involved?
We are actively looking to expand our team. For more info please send an email to info@marketprotocol.io
