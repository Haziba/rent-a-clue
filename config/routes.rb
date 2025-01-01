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

  namespace :admin do
    resources :users
    root to: "home#index"
    resources :inventory
    resources :puzzles
  end

  root to: "root#index", as: :anon_root
end
