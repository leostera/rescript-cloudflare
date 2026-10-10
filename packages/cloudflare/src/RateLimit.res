type binding
type result

type limitOptions = {key: string}

@send external limit: (binding, limitOptions) => promise<result> = "limit"
@get external success: result => bool = "success"
