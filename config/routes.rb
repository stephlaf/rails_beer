# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#home'

  get 'beers/new/:upc', to: 'beers#new_upc', as: 'new_upc'

  resources :beers do
    post :fetch_barcode, on: :collection
    get :scan, on: :collection
    resources :beer_tabs, only: %i[new create edit update]
  end

  resources :beer_tabs, only: %i[index show destroy]

  resources :breweries, only: %i[index show new create]

  resources :temp_beers, except: %i[new edit update]
  get 'temp_beers/new/:upc', to: 'temp_beers#new', as: 'temp_new_upc'

  # API routes

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'beers/all/', to: 'beers#all', as: 'all'
      get 'beers/search/:query', to: 'beers#search', as: 'search'
      get 'beers/:id', to: 'beers#show'
      post 'beers', to: 'beers#create'

      get 'breweries/all/', to: 'breweries#all', as: 'all_breweries'
    end
  end
end
