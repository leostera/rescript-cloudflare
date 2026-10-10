type env = {@as("BROWSER") browser: BrowserRendering.binding}

@module("@cloudflare/puppeteer") external puppeteer: BrowserRendering.puppeteerApi = "default"

let fetch = (_request: Web.request, env: env) =>
  Async.then(BrowserRendering.launch(puppeteer, env.browser), browser =>
    Async.then(BrowserRendering.newPage(browser), page =>
      Async.then(BrowserRendering.goto(page, "data:text/html,<title>local-browser</title>"), _ =>
        Async.then(BrowserRendering.title(page), title =>
          Async.map(BrowserRendering.close(browser), _ => Web.response(title))
        )
      )
    )
  )
