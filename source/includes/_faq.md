# FAQ

## What is MARKET Protocol? 
TLDR: MARKET Protocol, an open and permissionless protocol built on the Ethereum blockchain, provides the framework needed to create Position Tokens representing the prices of either crypto or traditional assets.

MARKET Protocol provides users with a trustless and secure framework for creating decentralized derivative Position Tokens, including the necessary collateral pool and position clearing infrastructure. Creating (or minting) positions results in ERC-20 tokens that function like derivatives by providing price exposure to a reference asset, either digital or traditional. Reference digital assets are not limited to ERC-20 tokens, allowing price exposure to cryptocurrencies like Bitcoin, Ripple, and Monero. With MARKET Protocol, traders will be able to gain long and short exposure to any asset. By utilizing a prefunded and shared collateral pool, all trades will always be solvent. 

## What is the purpose of the MARKET Protocol Token, MKT? 
At launch, MARKET Protocol’s native token MKT can be used to pay reduced Position Token minting fees on MPX.

There is a fixed supply of 600 million MKT tokens. MKT is listed and available for trading on [MPX](https://mpexchange.io/).

## What are Position Tokens?
Position Tokens are a way to gain price exposure, with safe leverage, to assets. They are ERC-20 tokens that can be traded on any exchange that supports the ERC-20 token standard.  When they are created (through a process we call minting) collateral is locked in a smart contract in return for long and short Position Tokens. The long tokens are worth more if the price of the asset goes up, and short tokens are worth more if the price goes down.

## What is sBTC and LBTC
sBTC is a position token that is short BTC/DAI.  As the price of BTC declines, sBTC increases in value.   

LBTC is a position token that is long BTC/DAI.  As the price of BTC goes up, LBTC increases in value.

## How do I price Position Tokens?
Please check out our [blog](https://cms.marketprotocol.io/blog/post/mpexplained-pricing-position-tokens/) post for more information on pricing position tokens.

## What are the components that make up a Position Token?
- Reference Asset: When the price of this asset moves, you gain or lose collateral. Example: BTC if you are trading BTC/DAI
- Collateral Token: The token deposited to the smart contract that is at stake in the trade. Example: DAI if you are trading BTC/DAI
- Price Band: A set Price Cap and Price Floor to ensure contracts are always fully collateralized, eliminating all counterparty risk
- Expiration: Each token has a time at which it expires. An expiration date is set when an underlying Position Token contract is created
- Value at expiration: This is the value a Position Token would be worth if it were to expire immediately

## How do I view the Price Floor and Price Cap of a Position Token?
You can view a Position Token’s Price Floor and Price Cap by navigating to the [MPX Dashboard](https://mpexchange.io/exchange), selecting the Position Token, and then by clicking the three dots to the right of the expiration countdown.

## Do Position Tokens come with leverage?
Position Tokens provide implicit leverage to their holders. For a trader acquiring a long token, the amount he trades for the token is the position’s maximum downside. This is always less than the notional value of the position (the current price of the reference asset).

The amount of leverage depends on the range of the contract (the difference between the Price Cap and Price Floor) relative to the price of a reference asset. All else equal, a narrower range provides more leverage than a wider range.

Leverage offered through MARKET Protocol Position Tokens differs from traditional leverage, which runs the risk of forced liquidations and unfunded positions. Instead, Position Tokens are fully backed by the collateral contributed during the token minting process. At any point in time, this collateral fully covers the maximum gain and loss of all tokens.

## Where can I view my current Position Tokens?
You can view your current Position Tokens in your wallet located on the [MPX Dashboard](https://mpexchange.io/dashboard).

## How do I know when a Position Token expires?
At the top of the [MPX Dashboard](https://mpexchange.io/exchange), you will see the current selected trading pair. For a selected Position Token, you can also see the expiration date, as well as a countdown to expiration.

## How do I know when a Position Token that I’m holding has expired?
You can view your Position Tokens and see if they have expired by navigating to the expired submenu in your wallet, located on the [MPX Dashboard](https://mpexchange.io/exchange). In the future, you will be able to set up personalized notifications.

## How do I redeem Position Tokens after settlement?
After settlement has occurred, plus a delay of 24 hours to ensure accuracy of settlement pricing, holders of short or long Position Tokens will be able to redeem their tokens. The smart contract will allocate Position Token holders the correct amount of collateral based on the settlement price of the contract. To redeem your tokens, navigate to the [MPX Mint/Redeem Positions dashboard](https://mpexchange.io/token).

## What oracle is used to settle Position Tokens?
Position Tokens use an internal oracle service built for MPX. This oracle sources data from price feeds provided by [CoinCap.io](https://coincap.io/).

## What happens if a Position Tokens expires based on an incorrect price?
We have a support team that can handle these inquiries. Users have 24 hours after expiration to initiate a dispute by contacting our team at support@marketprotocol.io. If an incorrect price is detected, then the contract will enter a disputed state. The value will be corrected, and the smart contract will subsequently distribute funds based on the correct price.

## What is shorting?
Shorting, or short-selling, is when a trader seeks to profit from a decline in the price of an asset.

## How does trading work?
BTC/DAI Position Token Trading Example:

Bob thinks BTC is going to decline in value. By holding short BTC/DAI tokens, he can profit if his view is correct. He has two ways he can go short BTC/DAI:

1. Go on any exchange (for example MPX) that lists short BTC/DAI and buy those tokens.
2. Or he could mint a pair of long and short Position Tokens and then sell his long tokens. After that, he’ll be left with only short BTC/DAI tokens.

## How does minting work?
Minting is the process of creating Position Tokens. The collateral, which is at stake in the trade, is locked in a smart contract. Once the collateral is locked, the minter receives freshly minted long and short Position Tokens in her wallet. She can then trade them with whomever she wants.

BTC/DAI Position Token Minting Example:

Alice wants to create BTC/DAI positions tokens. She goes to [MPX](https://mpexchange.io/) and clicks the [Mint/Redeem Positions](https://mpexchange.io/token) icon in the top right. Then she selects “Mint Tokens”. After selecting the BTC/DAI contract, she inputs the quantity of DAI she wants to lock and clicks “Approve Tokens for Minting”. Her DAI is removed from her wallet and locked in the smart contract. She now has both long BTC and short BTC tokens in her wallet.

## How much collateral is required to mint Position Tokens?
The required amount of collateral for your order will be automatically calculated when you select a quantity and price.

## How is the collateral necessary to mint Position Tokens calculated?
The amount of collateral required to mint a pair of Position Tokens can be calculated by taking the difference between the Price Cap and the Price Floor multiplied by the Quantity. The Price Cap and Price Floor are defined upon the deployment (creation) of a new Position Token contract. The collateral required to mint a pair of tokens represents the entire possible range of trading outcomes at settlement. A pair of long and short Position Tokens should always be worth this amount since the pair can be redeemed for a return of collateral at any time.

## How does redemption work?
Redemption is the opposite of minting. While minting creates Position Tokens and locks collateral, redemption is a process that destroys Position Tokens and releases collateral.

On MPX, click the [Mint/Redeem Positions](https://mpexchange.io/token) icon on the top right, then click “Redeem Tokens”. Next, select the contract for which you want to redeem tokens. Input the number of tokens you would like to redeem and click “Redeem Tokens”.  Please note that prior to expiration, you must redeem an equal amount of long and short tokens. After expiration you will be able to redeem either long or short tokens separately.

## How do I log in to MPX?
To interact with MPX, you will need to use the [MetaMask browser extension](https://metamask.io/). MetaMask allows you to connect to Ethereum dApps using your internet browser.

## Why is MPX not available in my region?
MPX is currently available only to users who are not residents of  the United States, Cuba, Iran, Syria, North Korea, the Crimea region.

## Is there an MPX mobile app or website?
MPX has been built to provide an optimal experience on desktop browsers. We will deliver a mobile-friendly experience in a future release.

## How do I begin trading Position Tokens?
To begin trading on MPX, you will need DAI. You can also use DAI as collateral to mint Position Tokens.

## What Position Tokens are available for trading on MPX?
We currently support trading of both long and short BTC/DAI tokens. Soon we will enable other Position Tokens like ETH/DAI and LTC/DAI, and also off-chain assets.

## Can I use ETH to trade on MPX?
Currently, ETH is not ERC-20 compliant. Instead, MPX allows for the use of wrapped ETH, or WETH, which itself is ERC-20 compliant. ETH can be wrapped and unwrapped using the [0x Portal](https://0x.org/portal/weth). Visit [www.weth.io](http://www.weth.io) for more information.

## Are there fees to use MPX?
Peer-to-peer trading is free on MPX, however, minting Position Tokens requires a small fee paid in DAI or MKT. If paid in MKT, then the fee is discounted.

## What is an order book?
An order book is a ledger containing all outstanding orders – inputs from traders looking to buy or sell an asset. An order to buy is called a ‘bid’ and an order to sell is called an ‘ask’.

## What is the difference between a maker and a taker?
A maker is a trader creating a new buy or sell order, while a taker is a trader filling an existing order. Makers create or ‘make’ liquidity, while takers take liquidity.

## How do I fill an order?
To fill an order in the order book, you select the order, choose the quantity you would like to trade, and then confirm the transaction through MetaMask.

## How do I create an order?
To create an order, you select whether your order is to buy or sell, choose the quantity, choose the price, input the expiration date and time, click to place the order, and then sign the order through MetaMask.

## Where can I view my pending orders?
You can view your orders on the [MPX Dashboard](https://mpexchange.io/dashboard).

## How do I know if my transaction was successful?
When you create or fill an order, you will receive a notification containing the transaction hash and a link to [Etherscan](https://etherscan.io/) where you can view your transaction.

## Where can I view my completed trades?
You can view your trade history on the [MPX Dashboard](https://mpexchange.io/dashboard).

## Is there a minimum amount required to make a trade?
No, there is no minimum required trade amount.
