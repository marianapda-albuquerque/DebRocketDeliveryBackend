Rails.application.routes.draw do
  devise_for :users

  post '/api/login',  to: 'api/auth#index'

  root to: "home#index"
  resources :employees

  namespace :api do
    resources :restaurants
    post '/order/:id/status', to: 'orders#status'
  end 
end
