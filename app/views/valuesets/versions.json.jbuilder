json.(@valueset, :id,:oid,:name,:code,
          :status,:statusDate,:definitionText,
          :scopeNoteText,:assigningAuthorityId,
          :valueSetCreatedDate,:valueSetLastRevisionDate)
json.versions do
  json.array! @versions do |version|
    json.id version.id
    json.version version.version_number
    json.url valueset_version_url(@valueset.oid,version.version_number)
  end
end
