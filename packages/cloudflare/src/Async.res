@send external then: (promise<'a>, 'a => promise<'b>) => promise<'b> = "then"
@send external map: (promise<'a>, 'a => 'b) => promise<'b> = "then"
@send external catch: (promise<'a>, JsExn.t => promise<'a>) => promise<'a> = "catch"
@val external resolved: 'a => promise<'a> = "Promise.resolve"
