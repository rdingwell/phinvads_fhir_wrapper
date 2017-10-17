class CodeSystemsController < ApplicationController

  def index
    @code_systems = VADS_SERVICE.getAllCodeSystems.getCodeSystems
  end

  def show
    @code_system = VADS_SERVICE.getCodeSystemByOid(params[:id]).getCodeSystem
    if params[:query]
        start = Time.now.to_i
        res = VADS_SERVICE.findCodeSystemConcepts(search, 1,100)
        @concepts = res.getCodeSystemConcepts
        logger.debug "time to search #{Time.now.to_i - start}"
        logger.debug  "total actual results #{res.totalResults}"
    else
      @concepts = retrieve_concepts(params[:id]) #VADS_SERVICE.getCodeSystemConceptsByCodeSystemOid(params[:id],1,1000).getCodeSystemConcepts
    end
  end

  private

  def search
    cscSearchCritDto = Java::GovCdcVocabServiceDtoInput::CodeSystemConceptSearchCriteriaDto.new
    cscSearchCritDto.setCodeSearch(params[:search_codes] == "true" || false)
    cscSearchCritDto.setNameSearch(params[:search_names]  == "true" || false )
    cscSearchCritDto.setPreferredNameSearch( false )
    cscSearchCritDto.setAlternateNameSearch(false )
    cscSearchCritDto.setDefinitionSearch(true)
    cscSearchCritDto.setSearchType(1)
    cscSearchCritDto.codeSystemOids = [params[:id]]
    cscSearchCritDto.setSearchText(params[:query])
    cscSearchCritDto
  end

  def retrieve_concepts(id)
    concepts = []
    page = 1
    limit = 100000
    loop do
      dto = VADS_SERVICE.getCodeSystemConceptsByCodeSystemOid(id, page, limit)
      concepts.concat dto.getCodeSystemConcepts
      page = page + 1
      puts "Concepts length #{concepts.length}  Total Results #{dto.getTotalResults()} Page #{page}"
      break if concepts.length >= dto.getTotalResults()
     end
    concepts
  end

end
