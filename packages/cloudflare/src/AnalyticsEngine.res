type dataset

type dataPoint = {
  blobs: option<array<string>>,
  doubles: option<array<float>>,
  indexes: option<array<string>>,
}

@send external writeDataPoint: (dataset, dataPoint) => unit = "writeDataPoint"
