Rails.application.routes.draw do
  get 'user_root/index'
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  authenticated :user do
    resources :subscriptions
    root to: "user_root#index", as: :user_root
  end

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  root to: "root#index", as: :anon_root
end
