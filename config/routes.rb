Rails.application.routes.draw do
  root to: "voter_signups#new"
  resources :rooms, only: [:create]

  resources :lead_signups, only: [:new, :create]
  resources :voter_signups, only: [:new, :create]
  resources :playlist, only: [:show] do
    resources :vote, only: [:update]
  end
end
