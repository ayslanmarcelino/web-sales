Rails.application.routes.draw do
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad

  root "enterprises#select"
  devise_for :users

  get 'dashboard/index'
  get 'report', to: 'dashboard#pdf'

  resources :profiles, only: :select

  resources :enterprises, only: [:index, :show, :new, :create, :edit, :update, :select] do
    member do
      patch :activate
      patch :disable
    end
  end

  namespace :admin do
    resources :users, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        patch :disable
        patch :activate
        patch :update_current_enterprise
        get :comments
      end
    end
  end

  namespace :user do
    resources :roles, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  resources :comments, only: [:index, :show, :new, :create]

  resources :measure_units, only: [:index, :new, :create]
end
