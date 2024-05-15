Rails.application.routes.draw do

  # Sesiones (Cap7)
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # Paginas estaticas
  root 'static_pages#home'
  
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  # Registro (Sign Up)
  get '/signup', to: 'users#new'  

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # Recurso de usuarios
  resources :users

  # Recurso para activacion de cuentas
  resources :account_activations, only: [:edit]

  # Recurso para reset de contraseñas
  resources :password_resets, only: [:new, :create, :edit, :update]

  # Recurso para microposts
  resources :microposts, only: [:create, :destroy]
  
end

