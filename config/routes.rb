Rails.application.routes.draw do
  namespace :preview do
    resources :contributors, only: [:index, :show]
  end
end
