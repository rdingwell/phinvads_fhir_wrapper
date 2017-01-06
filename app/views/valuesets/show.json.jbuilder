
json.(@valueset, :id,:oid,:name,:code,:status,
                   :statusDate,:definitionText,:scopeNoteText,
                   :assigningAuthorityId,:valueSetCreatedDate,
                   :valueSetLastRevisionDate)

json.version(@version,:id,:valueSetOid,:versionNumber,:description,:status,:statusDate,:assigningAuthorityText,:assigningAuthorityReleaseDate,:noteText,:effectiveDate,:expiryDate
)

json.expansion do
  json.identifier nil
  json.timestamp = nil
  json.contains do
    json.array! @concepts do |code|
      json.system code.codeSystemOid
      json.code code.conceptCode
      json.display code.codeSystemConceptName
      json.description code.definitionText
      json.valueSetVersionId code.valueSetVersionId
      json.vads(code, :id,:codeSystemOid ,:valueSetVersionId,:conceptCode,:scopeNoteText,:status,
      :statusDate,:cdcPreferredDesignation,:preferredAlternateCode,:definitionText,:codeSystemConceptName)

    end
  end
end
