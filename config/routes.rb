Rails.application.routes.draw do
  resources :users
  resources :articles
  resources :categories
  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'signup', to: 'users#new'
  post 'users', to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
