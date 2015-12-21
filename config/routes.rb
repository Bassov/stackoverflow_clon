Rails.application.routes.draw do
  devise_for :users
  resources :questions, shallow:true do
    resources :answers do
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resource :vote, only: [:vote_up, :vote_down, :unvote] do
    patch :vote_up, on: :member
    patch :vote_down, on: :member
    patch :unvote, on: :member
  end

  root 'questions#index'
end
