Rails.application.routes.draw do
  devise_for :users
  resources :questions, shallow:true do
    resources :answers do
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resource :vote, only: :vote do
    patch :vote, on: :member
  end

  root 'questions#index'
end
