Rails.application.routes.draw do
  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [:index, :show, :destroy]
  resource  :password, only: [:edit, :update]
  get '/orders/create', to: 'orders#create'
  post '/orders', to: 'orders#new'
  post '/home/indexHelper', to: 'home#indexHelper'
  post '/home/add', to: 'home#new'
  post '/cancel_order', to: 'orders#cancel_order'
  post 'orders/ship', to: 'orders#ship'
  post 'orders/make', to: 'orders#make'
  get '/orders/track', to: 'orders#track'
  get '/suppliers/info', to: 'suppliers#info'
  get '/suppliers/new', to: 'suppliers#new'
  post '/suppliers', to: 'suppliers#create'
  namespace :identity do
    resource :email,              only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset,     only: [:new, :edit, :create, :update]
  end
  resources :orders
  root "home#index"
end
