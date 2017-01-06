json.array! @valuesets do |vs|
  json.(vs[:valueset], :id,:oid,:name,:code,
            :status,:statusDate,:definitionText,
            :scopeNoteText,:assigningAuthorityId,
            :valueSetCreatedDate,:valueSetLastRevisionDate)
  json.versions do
    json.array! vs[:versions] do |version|
      json.(version,:id,:valueSetOid,:versionNumber,
                        :description,:status,:statusDate,
                        :assigningAuthorityText,:assigningAuthorityReleaseDate,
                        :noteText,:effectiveDate,:expiryDate )
      json.url valueset_version_url(vs[:valueset].oid,version.version_number)
    end
  end
  json.url valueset_url(vs[:valueset].oid.strip)
end
