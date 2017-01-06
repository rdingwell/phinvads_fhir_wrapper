Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    get 'valuesets', to: 'valuesets#index', as: :valuesets
    get 'valuesets/:id', to: 'valuesets#show', :constraints => { :id => /[[0-9]+\\.]*/ }, as: :valueset
    get 'valuesets/:id/versions', to: 'valuesets#versions', :constraints => { :id => /.*/ }, as: :valueset_versions
    get 'valuesets/:id/:version', to: 'valuesets#show', :constraints => { :id => /.*/ }, as: :valueset_version


    get 'code_systems', to: 'code_systems#index', as: :code_systems
    get 'code_systems/:id', to: 'code_systems#show', :constraints => { :id => /[[0-9]+\\.]*/ }, as: :code_system
end
