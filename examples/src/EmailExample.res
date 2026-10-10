type env = {@as("EMAIL") email: Email.binding}

let fetch = (_request: Web.request, env: env) => {
  let message = Email.message(
    "sender@example.test",
    "recipient@example.test",
    "From: sender@example.test\r\nTo: recipient@example.test\r\nMessage-ID: <local-test@example.test>\r\nSubject: local emulator test\r\n\r\nNot delivered anywhere.",
  )
  Async.map(Email.send(env.email, message), result => Web.response(Email.messageId(result)))
}
