json.resourceType  "Parameters"
json.parameter do
  json.array!  @results.keys do |k|
      json.name k
      json.set! (k == :result) ? "valueBoolean" : "valueString", @results[k]
  end
end
