type env = {@as("DB") database: D1.database}
type countRow = {count: int}

@send external firstCount: D1.statement => promise<Nullable.t<countRow>> = "first"
@get external rowCount: countRow => int = "count"

let fetch = (request: Web.request, env: env) => {
  let createTable = D1.prepare(env.database, "CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY, body TEXT NOT NULL)")
  Async.then(D1.run(createTable), _ =>
    if Web.requestMethod(request) == "POST" {
      Async.then(Web.requestText(request), body => {
        let insert = D1.bindString(D1.prepare(env.database, "INSERT INTO notes (body) VALUES (?)"), body)
        Async.then(D1.run(insert), _ => Async.resolved(Web.response("saved")))
      })
    } else if Web.requestMethod(request) == "DELETE" {
      let clear = D1.prepare(env.database, "DELETE FROM notes")
      Async.map(D1.run(clear), _ => Web.response("cleared"))
    } else {
      let select = D1.prepare(env.database, "SELECT COUNT(*) AS count FROM notes")
      Async.map(firstCount(select), row =>
        switch Nullable.toOption(row) {
        | Some(value) => Web.response(Int.toString(rowCount(value)))
        | None => Web.response("0")
        }
      )
    }
  )
}
