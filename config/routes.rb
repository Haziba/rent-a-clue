Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, path: 'users', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  devise_for :admins, path: 'admins', controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations',
    passwords: 'admins/passwords'
  }

  resources :subscriptions
  resources :rentals
  resource :account

  post '/checkout/session/create' => 'checkout/session#create'
  get '/checkout/session/:session_id/success' => 'checkout/session#success'
  get '/checkout/session/:session_id/cancel' => 'checkout/session#cancel'
  post '/checkout/webhook' => 'checkout/webhook#create'

  namespace :admin do
    resources :users
    root to: "home#index"
    resources :inventory
    resources :puzzles do
      resources :inventory
    end
  end

  root to: "root#index", as: :anon_root
end
