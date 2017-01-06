class ValuesetsController < ApplicationController

  def index
    valuesets = VADS_SERVICE.getAllValueSets.getValueSets
    versions = VADS_SERVICE.getAllValueSetVersions.getValueSetVersions
    temp = {}
    valuesets.each do |vs|
      temp[vs.oid] = {valueset: vs, versions:[]}
    end
    versions.each do |ver|
      temp[ver.valueSetOid][:versions] << ver
    end

    @valuesets = temp.values

  end

  def versions
    @valueset = VADS_SERVICE.getValueSetByOid(params[:id]).getValueSet
    @versions = VADS_SERVICE.getValueSetVersionsByValueSetOid(@valueset.oid).getValueSetVersions
  end

  def show
    @valueset = VADS_SERVICE.getValueSetByOid(params[:id]).getValueSet
    versions = VADS_SERVICE.getValueSetVersionsByValueSetOid(@valueset.oid).getValueSetVersions

    if params[:version]
      puts versions.length
      versions.each do |v|
        puts "num" + v.version_number.to_s
      end

      versions.each{|v| @version =  v if v.version_number.to_s == params[:version] || v.id == params[:version] }
      raise "crapppppppppp" unless @version
    else
      @version = versions[0]
    end
    @concepts = retrieve_concepts(@version)
  end


   private

   def retrieve_concepts(version)
     concepts = []
     dto = VADS_SERVICE.getValueSetConceptsByValueSetVersionId(version.id, 1, 1000)
     concepts.concat dto.getValueSetConcepts
     concepts
   end
end
