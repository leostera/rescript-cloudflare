type request
type response
type readableStream
type responseInit = {status: option<int>, headers: option<JSON.t>}

@new external requestFromUrl: string => request = "Request"
@new external response: string => response = "Response"
@new external responseFromNullable: Nullable.t<string> => response = "Response"
@new external responseWithOptions: (string, responseInit) => response = "Response"
@send external text: response => promise<string> = "text"
@send external clone: response => response = "clone"
@get external status: response => int = "status"
@get external requestMethod: request => string = "method"
@get external requestUrl: request => string = "url"
@send external requestText: request => promise<string> = "text"
@get external requestBody: request => Nullable.t<readableStream> = "body"
