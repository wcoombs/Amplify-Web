Rails.application.routes.draw do
  root to: "lead_signup#new"
  resources :room, only: [:create]

  resources :lead_signup, only: [:new, :create]
  resources :voter_signup, only: [:new, :create]
  resources :playlist, only: [:show] do
    resources :vote, only: [:update]
  end
end
