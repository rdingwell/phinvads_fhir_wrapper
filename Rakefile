# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks



require 'elasticsearch'
require 'jbuilder'

    # this is required to allow updating the adapter used by faraday
    # the argument is a symbol to the client so we need to change it
    # to make sure it works -- really required for testing using fake web

ES_CLIENT = Elasticsearch::Client.new adapter: :net_http

require "hessian-3.1.3.jar"
require "vocabServiceClient.jar"
require 'uri'

JAVA_SYSTEM = Java::JavaLang::System
PROXY = ENV["http_proxy"] || ENV["HTTP_PROXY"]
if PROXY
  uri = URI(PROXY)
  PROXY_HOST = uri.host
  PROXY_PORT = uri.port || 80
  JAVA_SYSTEM.setProperty("http.proxyHost",PROXY_HOST)
  JAVA_SYSTEM.setProperty("http.proxyPort",PROXY_PORT.to_s)
  JAVA_SYSTEM.setProperty("http.nonProxyHosts","localhost|127.0.0.1")
  JAVA_SYSTEM.setProperty("https.nonProxyHosts","localhost|127.0.0.1")
end

factory = com.caucho.hessian.client.HessianProxyFactory.new
VADS_SERVICE = factory.create(Java::GovCdcVocabService::VocabService.java_class,"http://phinvads.cdc.gov/vocabService/v2")

ENV_JAVA["http.proxyHost"] = PROXY_HOST
ENV_JAVA["http.proxyPort"] = PROXY_PORT.to_s
ENV_JAVA["https.nonProxyHosts"] = "localhost|127.0.0.1"
def retrieve_concepts(code_system )
  puts "Loading CodeSystem #{code_system.name}"
  processed = 0
  page = 1
  limit = 1000
  code_system_json = Jbuilder.new do |json|
      json.(code_system, :oid,:id,:name,:definitionText,:status,:statusDate,:version,
      :versionDescription,:acquiredDate,:effectiveDate,:expiryDate,
      :assigningAuthorityVersionName,:assigningAuthorityReleaseDate,
      :distributionSourceVersionName,:distributionSourceReleaseDate,
      :distributionSourceId,:sdoCreateDate,:lastRevisionDate,:sdoReleaseDate
     )
     json.suggest([code_system.name, code_system.oid])
  end
  if !ES_CLIENT.exists? index: 'phinvads', type: 'code_systems', id: code_system.id
    ES_CLIENT.create index: 'phinvads', type: 'code_systems', id: code_system.id, body: code_system_json.target!
  else
    ES_CLIENT.update index: 'phinvads', type: 'code_systems', id: code_system.id, body: {doc: code_system_json.target!}
  end
  loop do
    dto = VADS_SERVICE.getCodeSystemConceptsByCodeSystemOid(code_system.oid, page, limit)
    concepts =  dto.getCodeSystemConcepts
    processed = processed + concepts.length
    page = page + 1
    concepts.each do |c|
      #push to es
      cjson = Jbuilder.new do |json|
        json.(c, :id,:name,:codeSystemOid,:conceptCode,:sdoPreferredDesignation,
        :definitionText,:preCoordinatedFlag,:preCoordinatedConceptNote,
        :sdoConceptCreatedDate,:sdoConceptRevisionDate,:status,:statusDate,
        :sdoConceptStatus,:sdoConceptStatusDate,:supersededByCodeSystemConceptId,
        :umlsCui,:umlsAui)
        json.suggest([c.name, c.conceptCode])
      end
       unless ES_CLIENT.exists? index: 'codes', type: 'codes', id: c.id
         ES_CLIENT.create index: 'codes', type: 'codes', id: c.id, body: cjson.target!
       end
       unless ES_CLIENT.exists? index: 'code_systems', type: code_system.oid, id: c.id
         ES_CLIENT.create index: 'code_systems', type: code_system.oid, id: c.id, body: cjson.target!
       end
    end

    puts "Concepts length #{concepts.length}  Total Results #{dto.getTotalResults()} Page #{page}"
    break if processed >= dto.getTotalResults()

   end

end

task :load_es do
  @code_systems = VADS_SERVICE.getAllCodeSystems.getCodeSystems

  @code_systems.each do |cs|
    retrieve_concepts(cs)
  end
end
