# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount GrapeSwaggerRails::Engine => "/swagger"

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  resources :users, only: :show

  resources :questions, shallow: true do
    resources :comments, only: :create

    resources :answers, except: [:new, :show] do
      resources :comments, only: :create
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resource :vote do
    patch :create_vote, on: :member
  end

  resource :subscriptions, only: [:create, :destroy]

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:create, :index]
      end

      resources :answers, only: :show
    end
  end

  root "questions#index"
end
