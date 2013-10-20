Gigs::Application.routes.draw do
  resources :concerts

  get 'locations/:location/concerts', to: 'concerts#index'
end