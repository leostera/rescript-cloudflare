type binding
type readableStream
type transformer
type generator
type result

@send external input: (binding, readableStream) => transformer = "input"
@send external transform: (transformer, JSON.t) => generator = "transform"
@send external output: (generator, JSON.t) => result = "output"
@send external response: result => promise<Web.response> = "response"
@send external contentType: result => promise<string> = "contentType"
