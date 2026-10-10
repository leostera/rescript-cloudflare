type producer
type message
type messageBatch

type batchMessage = {
  body: JSON.t,
  contentType: option<string>,
  delaySeconds: option<int>,
}
type sendOptions = {delaySeconds: option<int>}
type retryOptions = JSON.t

@send external send: (producer, JSON.t) => promise<unit> = "send"
@send external sendString: (producer, string) => promise<unit> = "send"
@send external sendWithOptions: (producer, JSON.t, sendOptions) => promise<unit> = "send"
@send external sendBatch: (producer, array<batchMessage>) => promise<unit> = "sendBatch"

@get external messages: messageBatch => array<message> = "messages"
@send external ack: message => unit = "ack"
@send external retry: message => unit = "retry"
@send external retryWithOptions: (message, retryOptions) => unit = "retry"
@get external messageBody: message => JSON.t = "body"
@get external messageId: message => string = "id"
