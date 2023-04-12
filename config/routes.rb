Rails.application.routes.draw do
  devise_for :users, skip: [:sessions]

  devise_scope :user do
    get    'login',  to: 'devise/sessions#new',     as: :new_user_session
    post   '/api/login',  to: 'api/auth#index',  as: :user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  root to: "home#index"
  resources :employees
  resources :restaurants
end
