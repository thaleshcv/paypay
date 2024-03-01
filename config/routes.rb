Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, controllers: { registrations: "users/registrations" }

  unauthenticated do
    with_options controller: :pages do
      get "/", action: :landing
      get "/terms", action: :terms
      get "/privacy", action: :privacy
    end
  end

  authenticate :user do
    get "/", to: redirect("/dashboard")
    get "dashboard", to: "dashboard#index"

    devise_scope :user do
      get "/users/account", to: "users/registrations#show", as: :user_account
    end

    namespace :entries do
      resource :billing, only: %i[show new]
    end

    resources :categories, except: :show
    resources :billings, only: %i[show edit update] do
      patch :activate, on: :member
      patch :suspend, on: :member
    end

    resources :entries do
      get "pending", on: :collection
      resource :status, only: %i[edit update]
    end

    root "dashboard#index"
  end
end
