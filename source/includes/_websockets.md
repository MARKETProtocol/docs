# Socket.io Platform

The MPX socket.io server is provided for realtime updates and works as a great suppliment to the
[API](#api). [socket.io](https://socket.io) functions similarly to standard websockets, but
includes extra transport layers and namespacing ability to make listening to events slightly
easier than the standard firehose approach taken by most websocket implementations.

All data coming from the socket.io platform is in the same JSON:API format as the API returns. This
allows you to count on the data received being in the same format as you would get from a call to
the [API](#api).

## Connecting to the socket.io server

There are clients for socket.io written in several languages. When possible, we recommend using one
of the [official clients provided by socket.io](https://github.com/socketio/socket.io#features).
There are also third party implementations to be found online, but make sure the implementation you
choose is compatible with socket.io version 2.0.

For these documents, we will focus on showing examples using the standard JS client library.

We broadcast events on [namespaces](https://socket.io/docs/rooms-and-namespaces/). Events that are
not tied to a specific orderbook pair are sent over the `global` namespace. Events related to an
orderbook / token pair are broadcast over the namespace for that token pair (ex. `WETH-DAI`).
The event type is always `blockchainEvent`, although, this is likely to change in the future.

## Global events

```javascript
import io from 'socket.io-client';

// connect to the global namespace
const globalSocket = io('wss://socket.mpexchange.io/global');
```

Global events are related to the system as a whole and should always be listened for. At this time,
the only global event is `Maintenance Mode Change`.

## Maintenance Mode Change

```javascript
globalSocket.on('blockchainEvent', (name, data) => {
  if (name === 'Maintenance Mode Changed') {
    // do something
    // data.attributes.value === 'on' || 'off'
  }
});
```

When this event is triggered, it indicates that the platform has gone into or come out of
maintenance mode. When maintenance mode is `on`, all activity should be suspended. You can also
fetch this data at any time by making a `GET` request to
`https://api.mpexchange.io/settings/maintenance`.

## Token Pair Events

```javascript
import io from 'socket.io-client';

// connect to the token pair namespace
const wethDaiSocket = io('wss://socket.mpexchange.io/WETH-DAI');

wethDaiSocket.on('blockchainEvent', (name, data) => {
```

Token pair events happen inside of the pair's namespace.

There are three events which return an order, [Added to Orderbook](#added-to-orderbook), 
[Order State Change](#order-state-change), and [Removed from Orderbook](#removed-from-orderbook).
In each of these cases, the data will be the order in question. A fourth event, [Fill](#fill),
returns a fill object and can be used for tracking the trading history of a specific maker or taker
address.

## Added to Orderbook

```javascript
  if (name === 'Added to Orderbook') {
    // do something
    // data.id === '[the order hash]'
    // data.attributes === {[the order object]}
  }
```

When a new order is added to the token pair's orderbook, this event will be triggered. The data
will be a JSON:API representation of the order created. With orders, the id is always the order's
hash. We recommend you use this event to update your local copy of the orderbook instead of polling
the orderbook's API endpoint.

## Order State Change

```javascript
  if (name === 'Order State Change') {
    // do something
    // data.id === '[the order hash]'
    // data.attributes.state === 'cancelled' || 'expired' || 'filled' || 
    //                           'invalid' || 'open' ||'partially-filled' ||
    //                           'pending-cancel'
  }
```

This event is fired whenever an order's state changes. This can happen for numerous reasons, but
when the reason involves a state that causes the order to be removed from the orderbook for it's
token pair, a [Removed from Orderbook](#removed-from-orderbook) event will also be broadcast. We
suggest that you update your local copy of the order when you receive this type of event.

## Removed from Orderbook

```javascript
  if (name === 'Removed from Orderbook') {
    // do something
    // data.id === '[the order hash]'
  }
```

This event is fired whenever the order changes state to a non-valid or fully filled state. After
it is received, the order will no longer show up in the corresponding orderbook when querying the
API. We recommend you use this event to update your local copy of the orderbook.

## Fill

```javascript
  if (name === 'Fill') {
    // do something
  }
```

This event is fired whenever a new fill is received from the blockchain. You can use this to keep
track of the corresponding maker or taker's trading history for the token pair.

```javascript
});
```
