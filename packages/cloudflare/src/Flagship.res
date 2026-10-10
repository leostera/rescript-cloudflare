type binding

type context = JSON.t

@send external get: (binding, string) => promise<JSON.t> = "get"
@send external getValue: (binding, string, JSON.t) => promise<JSON.t> = "getValue"
@send external getBooleanValue: (binding, string, bool) => promise<bool> = "getBooleanValue"
@send external getStringValue: (binding, string, string) => promise<string> = "getStringValue"
