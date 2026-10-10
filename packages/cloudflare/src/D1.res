type database
type statement
type result
type columnInfo
type meta

type runOptions = {columnNames: option<bool>}

@send external prepare: (database, string) => statement = "prepare"
@send external bindString: (statement, string) => statement = "bind"
@send external bindInt: (statement, int) => statement = "bind"
@send external bindJson: (statement, JSON.t) => statement = "bind"
@send external first: statement => promise<Nullable.t<JSON.t>> = "first"
@send external firstByColumn: (statement, string) => promise<Nullable.t<JSON.t>> = "first"
@send external all: statement => promise<result> = "all"
@send external run: statement => promise<result> = "run"
@send external raw: statement => promise<array<array<JSON.t>>> = "raw"
@send external batch: (database, array<statement>) => promise<array<result>> = "batch"

@get external rows: result => array<JSON.t> = "results"
@get external success: result => bool = "success"
@get external meta: result => meta = "meta"
@get external changes: meta => int = "changes"
@get external lastRowId: meta => Nullable.t<float> = "last_row_id"
@get external duration: meta => Nullable.t<float> = "duration"
@get external columns: meta => array<columnInfo> = "column_names"
