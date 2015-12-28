Rails.application.routes.draw do
  devise_for :users
  resources :questions, shallow: true do
    resources :comments
    resources :answers, shallow: true do
      resources :comments
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resource :vote, only: :create do
    patch :create, on: :member
  end

  root 'questions#index'
end
