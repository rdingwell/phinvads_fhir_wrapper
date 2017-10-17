json.resourceType "ValueSet"
json.id @valueset.id
json.url	json.url valueset_url(@valueset.oid.strip)
json.identifier	do
  json.system "urn:ietf:rfc:3986"
  json.value 'urn:oid:' + @valueset.oid
end
json.version	@version.versionNumber
json.name	@valueset.name
json.status	@valueset.status
json.date	@valueset.valueSetLastRevisionDate
json.publisher "PHIN VADS"
json.description	@valueset.definitionText
json.expansion do
  json.identifier nil
  json.timestamp  nil
  json.total @concepts[:total]
  json.offset @concepts[:offset]
  json.contains do
    json.array! @concepts[:concepts] do |code|
      json.system "urn:oid:#{code.codeSystemOid}"
      json.code code.conceptCode
      json.display code.codeSystemConceptName
    end
  end
end
