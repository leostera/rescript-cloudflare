type env = {@as("VERSION") metadata: VersionMetadata.metadata}

let fetch = (_request: Web.request, env: env) => {
  let value = env.metadata
  Async.resolved(Web.response(VersionMetadata.id(value) ++ "|" ++ VersionMetadata.timestamp(value)))
}
