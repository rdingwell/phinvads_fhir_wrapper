require "hessian-3.1.3.jar"
require "vocabServiceClient.jar"
require 'uri'

JAVA_SYSTEM = Java::JavaLang::System
proxy = ENV["http_proxy"] || ENV["HTTP_PROXY"]
if proxy
  uri = URI(proxy)
  host = uri.host
  port = uri.port || 80
  JAVA_SYSTEM.setProperty("http.proxyHost",host)
  JAVA_SYSTEM.setProperty("http.proxyPort",port.to_s)
end

factory = com.caucho.hessian.client.HessianProxyFactory.new
VADS_SERVICE = factory.create(Java::GovCdcVocabService::VocabService.java_class,"http://phinvads.cdc.gov/vocabService/v2")
