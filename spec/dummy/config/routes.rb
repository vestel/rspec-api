Gigs::Application.routes.draw do
  resources :concerts
  resources :artists, only: [:index]

  get 'locations/:location/concerts', to: 'concerts#index'
end