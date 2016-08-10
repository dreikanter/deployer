Rails.application.routes.draw do
  resource :github_webhooks, only: :create, defaults: { formats: :json }
  resources :deployment_keys, except: :update
  root 'dashboard#show'
end
