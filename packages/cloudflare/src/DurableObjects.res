type namespace
type stub
type id

type storage
type storageTransaction

@send external idFromName: (namespace, string) => id = "idFromName"
@send external idFromString: (namespace, string) => id = "idFromString"
@send external newUniqueId: namespace => id = "newUniqueId"
@send external idToString: id => string = "toString"
@send external get: (namespace, id) => stub = "get"
@send external getByName: (namespace, string) => stub = "getByName"
@send external fetch: (stub, Web.request) => promise<Web.response> = "fetch"

@send external storageGet: (storage, string) => promise<Nullable.t<JSON.t>> = "get"
@send external storagePut: (storage, string, JSON.t) => promise<unit> = "put"
@send external storageDelete: (storage, string) => promise<bool> = "delete"
@send external storageList: storage => promise<JSON.t> = "list"
@send external transaction: (storage, (storageTransaction => promise<JSON.t>)) => promise<JSON.t> = "transaction"
@send external transactionGet: (storageTransaction, string) => promise<Nullable.t<JSON.t>> = "get"
@send external transactionPut: (storageTransaction, string, JSON.t) => unit = "put"
@send external transactionDelete: (storageTransaction, string) => bool = "delete"
@send external setAlarm: (storage, float) => promise<unit> = "setAlarm"
@send external getAlarm: storage => promise<Nullable.t<float>> = "getAlarm"
@send external deleteAlarm: storage => promise<unit> = "deleteAlarm"
