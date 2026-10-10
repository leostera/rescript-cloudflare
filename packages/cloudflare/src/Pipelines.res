type binding

type record = JSON.t

@send external send: (binding, array<record>) => promise<unit> = "send"
