json.resourceType  'Bundle'
json.type 'searchset'
json.entry do
  json.array! @valuesets do |vs|
    json.resourceType 'ValueSet'
    json.id vs[:valueset].id
    json.url	json.url valueset_url(vs[:valueset].oid.strip)
    json.identifier	do
      json.system 'urn:ietf:rfc:3986'
      json.value 'urn:oid:' + vs[:valueset].oid
    end
    json.name	vs[:valueset].name
    json.status	vs[:valueset].status
    json.date	vs[:valueset].valueSetLastRevisionDate
    json.publisher 'PHIN VADS'
    json.description	vs[:valueset].definitionText
  end
end
