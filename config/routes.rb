Rails.application.routes.draw do
  resources :competitions
  resources :teams
  resources :campaigns
  resources :matches
  resources :squads, only: [:new, :create, :edit, :update, :destroy]
  resources :players
  post '/matchesgenerator' => "competitions#matchesgenerator"
  
 
  get '/', to: 'statics#home', as: "home_page"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
