Rails.application.routes.draw do
  get 'rentals/show'
  resources :puzzles
  resources :puzzle_types
  get 'account/index'
  get 'user_root/index'
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  authenticated :user do
    resources :subscriptions
    resources :rentals
    resource :account
  end

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  root to: "root#index", as: :anon_root
end
