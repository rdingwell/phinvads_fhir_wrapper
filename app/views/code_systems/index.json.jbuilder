json.array! @code_systems do |cs|
 json.(cs, :oid,:id,:name,:definitionText,:status,:statusDate,:version,
 :versionDescription,:acquiredDate,:effectiveDate,:expiryDate,
 :assigningAuthorityVersionName,:assigningAuthorityReleaseDate,
 :distributionSourceVersionName,:distributionSourceReleaseDate,
 :distributionSourceId,:sdoCreateDate,:lastRevisionDate,:sdoReleaseDate
)
json.url code_system_url(cs.oid)
end
