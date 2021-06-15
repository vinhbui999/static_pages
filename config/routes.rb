Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'
  
  get 'sessions/new'
  resources :users
  get '/signup', to: 'users#new' #== signup_path
  get '/edit', to: 'users#edit'
  get '/help', to: 'static_pages#help' #== help_path
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root "application#hello"
  root "static_pages#home"
  get '/login', to: 'sessions#new' #this for login form
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :edit, :create, :update]
end
