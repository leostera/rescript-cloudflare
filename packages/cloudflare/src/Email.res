type binding
type message
type result

@module("cloudflare:email") @new external message: (string, string, string) => message = "EmailMessage"
@send external send: (binding, message) => promise<result> = "send"
@get external messageId: result => string = "messageId"
