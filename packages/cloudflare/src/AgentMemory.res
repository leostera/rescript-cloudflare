type namespace
type profile
type memory

type incomingMemory = {content: string, sessionId: option<string>}

type recallOptions = {
  thinkingLevel: option<string>,
  responseLength: option<string>,
}
type recallResult

@send external getProfile: (namespace, string) => promise<profile> = "getProfile"
@send external remember: (profile, incomingMemory) => promise<memory> = "remember"
@send external get: (profile, string) => promise<memory> = "get"
@send external delete: (profile, string) => promise<memory> = "delete"
@send external recall: (profile, string, recallOptions) => promise<recallResult> = "recall"
@send external getSummary: profile => promise<JSON.t> = "getSummary"
@send external deleteSession: (profile, string) => promise<unit> = "deleteSession"
