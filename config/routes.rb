Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Dev-only stubbed identity switcher (no real auth yet — see ApplicationController).
  resource :current_user, only: :update, controller: "current_users", as: :current_user_session

  resource :profile, only: :show, controller: "profile"

  # Live Markdown preview for the authoring forms (reuses the server renderer).
  post "markdown_preview", to: "markdown_previews#create"

  resources :courses do
    resource :enrollment, only: [ :create, :destroy ]
    resources :lessons do
      resources :time_logs, only: :create, controller: "lesson_time_logs"
      resource :quiz, only: [ :show, :edit, :update ] do
        resources :attempts, only: [ :create, :show ], controller: "quiz_attempts"
      end
    end
  end

  # Defines the root path route ("/")
  root "courses#index"
end
