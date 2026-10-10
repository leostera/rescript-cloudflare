type binding
type browser
type page
type puppeteerApi

type connectOptions = JSON.t

@send external launch: (puppeteerApi, binding) => promise<browser> = "launch"
@send external launchWithOptions: (puppeteerApi, binding, connectOptions) => promise<browser> = "launch"
@send external connect: (puppeteerApi, binding, connectOptions) => promise<browser> = "connect"
@send external newPage: browser => promise<page> = "newPage"
@send external goto: (page, string) => promise<unit> = "goto"
@send external title: page => promise<string> = "title"
@send external closePage: page => promise<unit> = "close"
@send external close: browser => promise<unit> = "close"
