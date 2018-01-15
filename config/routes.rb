Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "lead_signup#new"
  resources :lead_signup, only: [:new, :create]
end
