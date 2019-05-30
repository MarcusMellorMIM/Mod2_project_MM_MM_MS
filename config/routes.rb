Rails.application.routes.draw do
  resources :users
  resources :competitions
  resources :teams
  resources :campaigns
  resources :matches
  resources :squads, only: [:new, :create, :edit, :update, :destroy]
  resources :players
  post '/matchesgenerator' => "competitions#matchesgenerator"
  
 
  get '/', to: 'statics#home', as: "home_page"

  get "signup", to: "users#new", as: "signup"
  get "login", to: "sessions#new", as: "login"
  post "sessions", to: "sessions#create", as: "sessions"
  delete "sessions", to: "sessions#destroy"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
