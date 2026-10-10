type binding

type model = string

@send external run: (binding, model, JSON.t) => promise<JSON.t> = "run"
