Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get 'valuesets', to: 'valuesets#index', as: :valuesets,defaults: {format: :json}
    get 'valuesets/:id', to: 'valuesets#show', :constraints => { :id => /[[0-9]+\\.]*/ }, as: :valueset,defaults: {format: :json}
    get 'valuesets/:id/versions', to: 'valuesets#versions', :constraints => { :id => /.*/ }, as: :valueset_versions,defaults: {format: :json}
    get 'valuesets/:id/_history/:version', to: 'valuesets#show', :constraints => { :id => /.*/ }, as: :valueset_version,defaults: {format: :json}

    get 'code_systems', to: 'code_systems#index', as: :code_systems, defaults: {format: :json}
    get 'code_systems/:id', to: 'code_systems#show', :constraints => { :id => /[[0-9]+\\.]*/ }, as: :code_system, defaults: {format: :json}
end
