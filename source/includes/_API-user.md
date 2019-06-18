# API - User Accounts

While most endpoints can be accessed without providing identifying information, some actions
require basic user information.

_NOTE: The `/me` endpoint described in this section slightly diverges from the standard JSON:API
specification. This endpoint's actions expect and return `User` [Resource Objects](https://jsonapi.org/format/1.0/#document-resource-objects)
and are scoped to the provided [Authorization Bearer Token](#api-authentication)_

## View my user

```bash
curl -X GET -k -H 'Authorization: Bearer [TOKEN]' -i 'https://api.mpexchange.io/me'
```
```json
{
  "errors": [{
    "id": "04a49b6e-5215-4a35-9e2b-1c88c5a9a279",
    "status": "Not Found",
    "code": "404",
    "title": "The origin server did not find a current representation for the target resource or is not willing to disclose that one exists.",
    "detail": "Could not find a user with id 0x2846a3e4c616f652dea0140cfda189363e64f07f."
  }],
  "jsonapi": {
    "version": "1.0"
  },
  "meta": {
    "template": {
      "email-address": {
        "required": true,
        "type": "string"
      },
      "first-name": {
        "required": true,
        "type": "string"
      },
      "last-name": {
        "required": true,
        "type": "string"
      },
      "has-confirmed-not-sanctioned": {
        "required": true,
        "type": "boolean"
      },
      "has-confirmed-not-us-citizen": {
        "required": true,
        "type": "boolean"
      },
      "terms-and-condition-hash": {
        "required": true,
        "type": "string"
      }
    }
  }
}
```

If you've ever created a `User` [Resource Object](https://jsonapi.org/format/1.0/#document-resource-objects),
you can access it by making a request to `GET /me` with your [Authorization Token](#api-authentication).

This endpoint will either return the `User` or a not found error with a 404 status code. The
response will also include a template for creating a new user which contains the names of each
attribute, a boolean indicating if it is required, and [the data type](#api-data-types) of it's
value.

## Create a user

```bash
curl -X POST -k -H 'Authorization: Bearer [TOKEN]' -i 'https://api.mpexchange.io/me' --data '{
  "data": {
    "type": "users",
    "attributes": {
      "email-address": "user@marketprotocol.io",
      "first-name": "First",
      "last-name": "Last",
      "has-accepted-terms-and-conditions": true,
      "has-confirmed-not-us-citizen": true,
      "terms-and-condition-hash": "1.0"
    }
  }
}'
```

To access the authenticated endpoints which require a `User`, you will first have to create one.
At the time of this writing, a valid user requires an `email-address`, `first-name`, `last-name`,
and several attributes which confirm eligibility to use the platform. Create the user by making a
request to `POST /me` with a valid `User` [Resource Object](https://jsonapi.org/format/1.0/#document-resource-objects)
as the request body.

## The user resource object

```json
{
  "data": {
    "type": "users",
    "id": "0x2846a3e4c616f652cda0140ceda189363e64e55e",
    "attributes": {
      "email-address": "user@marketprotocol.io",
      "eth-address": "0x2846a3e4c616f652cda0140ceda189363e64e55e",
      "first-name": "First",
      "last-name": "Last",
      "is-admin": false,
      "is-email-confirmed": false,
      "is-ky-ced": false,
      "remaining-minting-limit": "18000"
    }
  },
  "jsonapi": {
    "version": "1.0"
  }
}
```

