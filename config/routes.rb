Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users, only: :show

  resources :questions, shallow: true do
    resources :comments, only: :create

    resources :answers do
      resources :comments, only: :create
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resource :vote, only: :create do
    patch :create_vote, on: :member
  end

  root 'questions#index'
end
