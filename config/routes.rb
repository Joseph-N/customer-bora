CustomerBora::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'home#index'

  devise_for :users

  resources :users
  resources :push_messages, only: [:create]
  resources :leaderboard, only: [:index]
  resources :dashboard

  post 'contact', to: 'home#contact', as: :contact
  post 'sms', to: 'dashboard#sms', as: :sms
  post "custom_sms", to: "dashboard#custom_sms", as: :custom_sms
end
