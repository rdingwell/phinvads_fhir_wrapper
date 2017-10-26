class ValuesetsController < ApplicationController

  caches_action :index, expires_in: 1.day
  caches_action :show, cache_path: Proc.new {request.url}
  # GET /valuesets/
  def index
    valuesets = VADS_SERVICE.getAllValueSets.getValueSets
    temp = {}
    valuesets.each do |vs|
      temp[vs.oid] = { valueset: vs, versions: [] }
    end
    @valuesets = temp.values
  end

  # GET /valuesets/:id
  # GET /valuesets/:id/_history/:version
  def show
    # using oid as the identifier, as vads api accesses the versions
    # separatly need to first get the valueset for it's meta-data and
    # then retrieve the version information for the codes in that version
    @valueset = VADS_SERVICE.getValueSetByOid(params[:id]).getValueSet
    versions = VADS_SERVICE.getValueSetVersionsByValueSetOid(@valueset.oid).getValueSetVersions
    versions.sort!{|a,b| b.versionNumber <=>  a.versionNumber }

    if params[:version]
      versions.each do |v|
        @version = v if v.version_number.to_s == params[:version] || v.id == params[:version]
      end
      raise 404 unless @version
    else
      @version = versions[0]
    end
    # set the limit and offsets for retrieving codes
    # the max limit of codes is set to 1000 for perform issues
    limit = params[:count] ? params[:count].to_i : 1000
    limit = limit > 1000 ? 1000 : limit
    offset = params[:offset] ? params[:offset].to_i : 0
    # Due to the way VADS does paging we must enforce that they
    # offset is a multiple of the limit
    if (offset % limit) != 0
      raise "Offset must be evenly divisible by limit"
    end
    page =  (offset/limit) + 1
    @concepts = retrieve_concepts(@version, page, limit).merge(offset: offset)
  end

  def validate
    res = /urn:oid:(.*)/.match(params[:system])
    if res && res[1]
      validateDTO = VADS_SERVICE.validateConceptValueSetMembership(res[1], params[:code],params[:id],params[:version])
      @results = {result: validateDTO.valid,   message:validateDTO.errorText }
    else
      raise "Invalid code system uri #{params[:system]}"
    end
  end

  private

  def retrieve_concepts(version, page, limit)
    concepts = []
    dto = VADS_SERVICE.getValueSetConceptsByValueSetVersionId(version.id, page, limit)
    concepts.concat dto.getValueSetConcepts
    {concepts: concepts,  total:  dto.getTotalResults}
  end
end
