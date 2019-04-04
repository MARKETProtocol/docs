# API - Endpoints

```bash
curl -X GET -k -i 'https://api.mpexchange.io'
```

A list of all available endpoints can be accessed by making a get request to the root endpoint
(`GET /`). The response body will include a [Links](https://jsonapi.org/format/1.0/#document-links)
object whose keys are the base path for each endpoint. Each corresponding value contains a
description, a list of actions, and a list of HTTP methods available. Also included will be an
array of available filters for the `index` action and a template for the `create` action, if
appropriate.

```json
{
  "links": {
```

## /contracts

```json
    "contracts": {
      "href": "http://api.mpexchange.io/contracts",
      "meta": {
        "actions": ["index", "show"],
        "description": "...",
        "methods": ["GET"],
        "filters": ["isSettled", "isWhitelisted"]
      }
    },
```

Provides a list of MARKET Protocol contracts. Individual contracts can be queried via the show
endpoint.

## /fee_recipients

```json
    "fee_recipients": {
      "href": "http://api.mpexchange.io/fee_recipients",
      "meta": {
        "actions": ["index"],
        "description": "...",
        "methods": ["GET"]
      }
    },
```

Provides a list of fee recipients. Orders must have the correct fee recipient in order to be
accepted.

## /fills

```json
    "fills": {
      "href": "http://api.mpexchange.io/fills",
      "meta": {
        "actions": ["index", "show"],
        "description": "...",
        "methods": ["GET"],
        "filters": [
          "maker-address",
          "maker-asset-address",
          "maker-asset-data",
          "order-hash",
          "pair-name",
          "sender-address",
          "taker-address",
          "taker-asset-address",
          "taker-asset-data",
          "transaction-hash"
        ]
      }
    },
```

Provides a list of fills. Individual fills can be queried via the show endpoint.

## /json_web_tokens

```json
    "json_web_tokens": {
      "href": "http://api.mpexchange.io/json_web_tokens",
      "meta": {
        "actions": ["show", "update"],
        "description": "...",
        "methods": ["GET", "PATCH", "PUT"]
      }
    }
```

Allows for the creation of JWT tokens. See more in the [Authentication](#api-authentication)
section of this documentation.

## /orderbooks

```json
    "orderbooks": {
      "href": "http://api.mpexchange.io/orderbooks",
      "meta": {
        "actions": ["index", "show"],
        "description": "...",
        "methods": ["GET"]
      }
    },
```

Returns a list of available orderbooks. Each orderbook can be retrieved in full at the show
endpoint.


## /orders

```json
    "orders": {
      "href": "http://api.mpexchange.io/orders",
      "meta": {
        "actions": ["create", "destroy", "index", "show"],
        "description": "...",
        "methods": ["DELETE", "GET", "POST"],
        "filters": [
          "exchange-address",
          "maker-address",
          "maker-asset-address",
          "maker-asset-data",
          "pair-name",
          "sender-address",
          "state",
          "taker-asset-address",
          "taker-asset-data"
        ],
        "template": {
          "exchange-address": {
            "required": true,
            "type": "string"
          },
          "expiration-time-seconds": {
            "required": true,
            "type": "number"
          },
          "fee-recipient-address": {
            "required": true,
            "type": "string"
          },
          "hash": {
            "required": true,
            "type": "string"
          },
          "maker-address": {
            "required": true,
            "type": "string"
          },
          "maker-asset-amount": {
            "required": true,
            "type": "number"
          },
          "maker-asset-data": {
            "required": true,
            "type": "string"
          },
          "maker-fee": {
            "required": true,
            "type": "number"
          },
          "salt": {
            "required": true,
            "type": "number"
          },
          "sender-address": {
            "required": true,
            "type": "string"
          },
          "signature": {
            "required": true,
            "type": "string"
          },
          "state": {
            "required": true,
            "type": "string"
          },
          "taker-address": {
            "required": true,
            "type": "string"
          },
          "taker-asset-amount": {
            "required": true,
            "type": "number"
          },
          "taker-asset-data": {
            "required": true,
            "type": "string"
          },
          "taker-fee": {
            "required": true,
            "type": "number"
          }
        }
      }
    },
```

Returns a list of all orders. Individual orders can be retrieved via the show endpoint.
Authenticated users can also create new orders and delete (cancel) their own orders. The
cancellation must also take place on chain to ensure an order is no longer able to be filled, but a
call to here will remove it from our orderbooks.

_NOTE: To create a user, please visit the [MARKETProtocol Exchange](https://mpexchange.io) and
follow the registration process._

## /settings

```json
    "settings": {
      "href": "http://api.mpexchange.io/settings",
      "meta": {
        "actions": ["index", "show"],
        "description": "...",
        "methods": ["GET"]
      }
    },
```

Returns a list of system wide settings.

## /token_pairs

```json
    "token_pairs": {
      "href": "http://api.mpexchange.io/token_pairs",
      "meta": {
        "actions": ["index", "show"],
        "description": "...",
        "methods": ["GET"],
        "filters": [
          "base-token-address",
          "base-token-asset-data",
          "base-token-symbol",
          "is-enabled",
          "is-market-position-token",
          "pair-name",
          "quote-token-address",
          "quote-token-asset-data",
          "quote-token-symbol"
        ]
      }
    },
```

Provides a list of all Token Pairs being traded on the platform.


```json
    "self": {
      "href": "http://api.mpexchange.io",
      "meta": {
        "actions": ["index"],
        "description": "...",
        "methods": ["GET"]
      }
    }
  },
  "meta": {
    "about": "This API is provided to interact with MPX and MARKET Protocol. It implements a custom version of the 0x Protocol relayer API",
    "copyright": "Copyright 2019 Market Protocol LLC",
    "license": "license goes here",
    "support": "support@marketprotocol.io",
    "website": "https://mpexchange.io"
  },
  "jsonapi": {
    "version": "1.0"
  }
}
```
