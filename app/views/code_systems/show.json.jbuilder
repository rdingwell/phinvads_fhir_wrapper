json.resourceType "CodeSystem"
json.id @code_system.id
json.url code_system_url(@code_system.oid)
json.identifier	do
  json.system "urn:ietf:rfc:3986"
  json.value 'urn:oid:' + @code_system.oid
end
json.version	@code_system.version
json.name	@code_system.name
json.status	@code_system.status
json.date	@code_system.lastRevisionDate
json.publisher "PHIN VADS"
json.description	@code_system.definitionText
json.concept do
  json.array! @concepts do |concept|
    json.code concept.conceptCode
    json.display concept.name
    json.definition concept.definitionText
  end
end
