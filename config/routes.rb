Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, path: 'users', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  get 'verify_email', to: 'devise/confirmations#pending', as: :verify_email

  devise_for :admins, path: 'admins', controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords'
  }

  get 'terms-and-conditions' => 'legal#terms_and_conditions', as: :terms_and_conditions
  get 'privacy-policy' => 'legal#privacy_policy', as: :privacy_policy

  resources :subscriptions
  resources :rentals
  resource :account
  resource :contact
  resources :puzzles, only: %i[index show]
  resources :fines, only: [] do
    member do
      post 'pay' => 'fines#pay'
    end
  end

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
    resources :rentals do
      resource :reviews, controller: 'rental_reviews' do
        resource :fines
      end
    end
    get '/parcels/labels' => 'parcels#labels'
  end

  root to: "root#index", as: :anon_root

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
