Rails.application.routes.draw do
  get 'users_imports/new'

  resources :users
  resources :users_imports, only: [:new, :create]
  root to: 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
