# API - Authentication

```bash
curl -X GET -k -H 'Authorization: Bearer [TOKEN]' -i 'https://api.mpexchange.io'
```

The MARKETProtocol API uses JWT bearer tokens sent in the Authorization header for authenticating
requests. Any ETH address can obtain a valid JWT without further registration.

## Obtain an unsigned token and nonce.

```bash
curl -X GET -k -i 'https://api.mpexchange.io/json_web_tokens/0x2846A3E4c616F652DEA0140Cfda189363E64f07f'
```
```json
{
  "data": {
    "type": "json-web-tokens",
    "id": "0x2846a3e4c616f652dea0140cfda189363e64f07f",
    "attributes": {
      "nonce": "5c45b580-b1a1-4d42-89c3-34b164c4c242",
      "signature": null,
      "token": "ieyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
  },
  "jsonapi": {
    "version": "1.0"
  }
}
```

Begin by requesting an unsigned token and nonce from the `GET /json_web_tokens/:address`endpoint.

## Sign the nonce

```bash
curl -X PUT -k -i 'https://api.mpexchange.io/json_web_tokens/0x2846A3E4c616F652DEA0140Cfda189363E64f07f' --data '{
  "data": {
    "type": "json-web-tokens",
    "id": "0x2846a3e4c616f652dea0140cfda189363e64f07f",
    "attributes": {
      "nonce": "5c45b580-b1a1-4d42-89c3-34b164c4c242",
      "signature": "0x9c8df72254b38f8a6ab5107b5e977...",
      "token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
  }
}'
```

```json
{
  "data": {
    "type": "json-web-tokens",
    "id": "0x2846a3e4c616f652dea0140cfda189363e64f07f",
    "attributes": {
      "nonce": "5c45b580-b1a1-4d42-89c3-34b164c4c242",
      "signature": "0x9c8df72254b38f8a6ab5107b5e977...",
      "token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
  },
  "jsonapi": {
    "version": "1.0"
  }
}
```

A nonce value will be returned at the JSON path `/data/attributes/nonce`. Sign it with your ETH
address and compose a `PUT` or `PATCH` request to the same endpoint. The body of the request
should be a `json-web-tokens` [Resource·Object](https://jsonapi.org/format/1.0/#document-resource-objects)
containing the original `nonce`, unsigned `token`, and the signed nonce as `signature`.

_NOTE: The easiest way to sign the nonce manually is with [MEW](https://www.myetherwallet.com)._

The resulting response will include your valid JWT bearer token in at the JSON path
`/data/attributes/token`. Please note that the token returned from the initial get request is not
valid for use as an Authorization bearer token. Only the token returned from the second request can
be used as a bearer token.

## First time authentication

Though it is possible to sign in and access the read only sections of the API with any ETH address,
basic user information must be provided in order to create orders or otherwise trade. Please visit
the [MARKETProtocol Exchange](https://mpexchange.io) and sign up for a user account using the ETH
address you intend to use with the API. Until you do so, several of the endpoints described later
in this documentation will return an unauthorized response.
