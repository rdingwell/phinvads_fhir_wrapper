class CodeSystemsController < ApplicationController
  caches_action :index, expires_in: 1.day
  caches_action :show, cache_path: Proc.new {request.url}

  # GET /code_systems
  def index
    @code_systems = VADS_SERVICE.getAllCodeSystems.getCodeSystems
  end

  # GET /code_systems/:id
  def show
    @code_system = VADS_SERVICE.getCodeSystemByOid(params[:id]).getCodeSystem
    @concepts = retrieve_concepts(params[:id])
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
      logger.debug  "Concepts length #{concepts.length}  Total Results #{dto.getTotalResults()} Page #{page}"
      page = page + 1
      break if concepts.length >= dto.getTotalResults()
     end
    concepts
  end

end
