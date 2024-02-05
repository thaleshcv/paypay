Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  authenticate :user do
    get "dashboard", to: "dashboard#index"

    namespace :entries do
      resource :billing, only: %i[show new]
    end

    resources :categories, except: :show
    resources :entries do
      get "pending", on: :collection
      resource :status, only: %i[edit update]
    end

    root "dashboard#index"
  end

  get "/", to: redirect("/dashboard")
end
