type index
type mutation
type matches

type queryOptions = {
  topK: option<int>,
  namespace: option<string>,
  returnValues: option<bool>,
  returnMetadata: option<bool>,
  filter: option<JSON.t>,
}

@send external insert: (index, array<JSON.t>) => promise<mutation> = "insert"
@send external upsert: (index, array<JSON.t>) => promise<mutation> = "upsert"
@send external query: (index, array<float>, queryOptions) => promise<matches> = "query"
@send external getByIds: (index, array<string>) => promise<array<JSON.t>> = "getByIds"
@send external deleteByIds: (index, array<string>) => promise<mutation> = "deleteByIds"
@send external describe: index => promise<JSON.t> = "describe"
