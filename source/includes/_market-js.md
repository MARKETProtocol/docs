# MARKET.js

All code for this library can be found [here](https://github.com/MARKETProtocol/MARKET.js). If you have any
issues to report or features to request please do so by opening an issue on 
[GitHub](https://github.com/MARKETProtocol/MARKET.js/issues).

**Under Construction**


## Order Life Cycle

Note: this is the generalized lifecycle, function calls will be replaced with MARKET.js function calls that provide
a simplified abstraction to the underlying solidity calls. 

1. An order is generated from a `maker` as described [here](#orders). Signing and hashing this order allows for us
to confirm its validity.
1. Depending on the application, this order may then be broadcast to a third party order book host who may provide
further verifications before publishing the order to their orders books, including: 
  * Verifying sufficient funding in the MARKET Contract for the maker's address
  * Validating user has locked MKT to allow for access for trading the specified MARKET Protocol smart contract.
1. The specified taker, or an arbitrary taker (if none specified) is able to call the `traderOrder` function filling 
all or a partial qty of the order.  This transaction happens on-chain and therefore validates all aspects of the transaction are
successful.
1.  Third party order book hosts will be responsible for removing completely filled or completely cancelled orders from 
their order books.  Orders can be cancelled by setting an `expirationTimeStamp` or by calling the function `cancelOrder`
at any time

## Requirements for a successful `traderOrder` call

In order for a taker to not waste gas on a call to `traderOrder` that will ultimately fail it is important to note 
the following requirements in order for a transaction to be executed.

1. `MarketContract` must be deployed correctly, linked to a `MarketCollateralPool` and not be in an `isSettled` state
1. Both `maker` and `taker` must have locked the requisite amount of MKT to enable trading for the specific contract.
This can be verified by calling `isUserEnabledForContract` in the `MarketToken` smart contract (not enforced on Rinkeby currently). 
1. caller of `tradeOrder` is either the specified `taker` in the order, or no taker was specified
1. the `maker` and `taker` are not the same address (no [wash](https://en.wikipedia.org/wiki/Wash_trade) trading)
1. the order has not expired, been cancelled, or been completely filled
1. both `maker` and `taker` have sufficient balances to lock collateral for attempted trade        
