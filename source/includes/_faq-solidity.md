# FAQ - Solidity Smart Contracts

### How to debug MARKET protocol tests?
First option is to use console.log() to display Javascript objects and their properties on the console during test execution. This works well for simple cases, for more difficult scenarios one should set an asynchronous event watcher and expect events sent from Solidity contracts. For tests that have expectation on price or asynchronously wait for contract settlement it is also possible to manually update price using TestableMarketContractOraclize contract to verify correctness of the contract flow.
