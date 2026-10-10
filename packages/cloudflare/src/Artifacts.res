type binding
type repository
type file

type createOptions = {
  readOnly: option<bool>,
  description: option<string>,
  setDefaultBranch: option<string>,
}
type readFileOptions = {ref: string, path: string}

@send external create: (binding, string, createOptions) => promise<JSON.t> = "create"
@send external get: (binding, string) => promise<repository> = "get"
@send external list: (binding, JSON.t) => promise<JSON.t> = "list"
@send external delete: (binding, string) => promise<bool> = "delete"
@send external info: repository => promise<JSON.t> = "info"
@send external readFile: (repository, readFileOptions) => promise<Nullable.t<file>> = "readFile"
@send external log: (repository, JSON.t) => promise<array<JSON.t>> = "log"
