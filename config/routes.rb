CustomerBora::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'home#index'

  devise_for :users

  resources :users
  resources :push_messages, only: [:create]
  resources :leaderboard

  post 'contact', to: 'home#contact', as: :contact
end
