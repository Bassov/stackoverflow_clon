Rails.application.routes.draw do
  devise_for :users
  resources :questions, shallow:true do
    resources :answers do
      patch :make_best, on: :member
      patch :vote_up, on: :member
      patch :vote_down, on: :member
    end
  end

  resources :attachments, only: :destroy

  root 'questions#index'
end
