Rails.application.routes.draw do
  devise_for :users

  post '/api/login',  to: 'api/auth#index'

  root to: "home#index"

  namespace :api do
    resources :restaurants, :employees
  end 
end
