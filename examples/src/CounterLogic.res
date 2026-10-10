type storage = DurableObjects.storage

@send external getCount: (storage, string) => promise<Nullable.t<int>> = "get"
@send external putCount: (storage, string, int) => promise<unit> = "put"

@val external now: unit => float = "Date.now"

let current = (storage: storage) =>
  Async.map(getCount(storage, "count"), stored =>
    switch Nullable.toOption(stored) {
    | Some(count) => Int.toString(count)
    | None => "0"
    }
  )

let scheduleAlarm = (storage: storage) =>
  DurableObjects.setAlarm(storage, now() +. 10.)

let next = (storage: storage) =>
  Async.then(getCount(storage, "count"), stored => {
    let previous = switch Nullable.toOption(stored) {
    | Some(count) => count
    | None => 0
    }
    let current = previous + 1
    Async.map(putCount(storage, "count", current), _ => current)
  })
