json.(@code_system, :oid,:id,:name,:definitionText,:status,:statusDate,:version,
:versionDescription,:acquiredDate,:effectiveDate,:expiryDate,
:assigningAuthorityVersionName,:assigningAuthorityReleaseDate,
:distributionSourceVersionName,:distributionSourceReleaseDate,
:distributionSourceId,:sdoCreateDate,:lastRevisionDate,:sdoReleaseDate
)

json.concepts do
  json.array! @concepts do |concept|
    json.(concept, :id,:name,:codeSystemOid,:conceptCode,:sdoPreferredDesignation,
    :definitionText,:preCoordinatedFlag,:preCoordinatedConceptNote,
    :sdoConceptCreatedDate,:sdoConceptRevisionDate,:status,:statusDate,
    :sdoConceptStatus,:sdoConceptStatusDate,:supersededByCodeSystemConceptId,
    :umlsCui,:umlsAui)
  end
end
