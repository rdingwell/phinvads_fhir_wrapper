class ValuesetsController < ApplicationController

  caches_action :index, expires_in: 1.day
  caches_action :show, cache_path: Proc.new {request.url}

  def index
    valuesets = VADS_SERVICE.getAllValueSets.getValueSets
    temp = {}
    valuesets.each do |vs|
      temp[vs.oid] = { valueset: vs, versions: [] }
    end
    @valuesets = temp.values
  end

  def show
    @valueset = VADS_SERVICE.getValueSetByOid(params[:id]).getValueSet
    versions = VADS_SERVICE.getValueSetVersionsByValueSetOid(@valueset.oid).getValueSetVersions
    versions.sort!{|a,b| b.versionNumber <=>  a.versionNumber }
    if params[:version]
      versions.each { |v| @version = v if v.version_number.to_s == params[:version] || v.id == params[:version] }
      raise 'No such version #{params[:version]}' unless @version
    else
      @version = versions[0]
    end
    limit = params[:count] ? params[:count].to_i : 1000
    limit = limit > 1000 ? 1000 : limit
    offset = params[:offset] ? params[:offset].to_i : 0
    if (offset % limit) != 0
      raise "Offset must be evenly divisible by limit"
    end
    page =  (offset/limit) + 1
    @concepts = retrieve_concepts(@version, page, limit).merge(offset: offset)

  end

  private

  def retrieve_concepts(version, page, limit)
    concepts = []
    dto = VADS_SERVICE.getValueSetConceptsByValueSetVersionId(version.id, page, limit)
    concepts.concat dto.getValueSetConcepts
    {concepts: concepts,  total:  dto.getTotalResults}
  end
end
