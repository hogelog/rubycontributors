Rails.application.routes.draw do
  root 'contributors#index'
  resources :contributors, only: [:show, :update]
  
  namespace :static do
    resources :contributors, only: [:index, :show]
    resource :about, only: [:show]
  end
end
