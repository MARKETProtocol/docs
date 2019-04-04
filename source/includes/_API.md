# API

## Introduction

The MARKETProtocol API follows the [JSON:API 1.0 specification](https://jsonapi.org/format/1.0).
Per the spec, the `application/vnd.api+json` media type should be used for all requests.
All responses will also be provided in this media type. Response bodies will always include
[Resource Objects](https://jsonapi.org/format/1.0/#document-resource-objects),
[Error Objects](https://jsonapi.org/format/1.0/#error-objects), or
[Links](https://jsonapi.org/format/1.0/#document-links).

