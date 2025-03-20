Rails.application.routes.draw do
  root 'contributors#index'
  resources :contributors, only: [:show, :update]
  
  namespace :preview do
    resources :contributors, only: [:index, :show]
  end
end
