class CodeSystemsController < ApplicationController

  def index
    @code_systems = VADS_SERVICE.getAllCodeSystems.getCodeSystems
  end

  def show
    @code_system = VADS_SERVICE.getCodeSystemByOid(params[:id]).getCodeSystem
    @concepts = VADS_SERVICE.getCodeSystemConceptsByCodeSystemOid(params[:id],1,1000).getCodeSystemConcepts
  end
end
