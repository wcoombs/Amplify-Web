Rails.application.routes.draw do
  root to: "voter_signups#new"

  constraints subdomain: "api" do
    scope module: 'api' do
      namespace 'v1' do
        resources :rooms, only: [:create, :destroy, :index]
        resources :hosts, only: [:create]

        get '/refresher/refresh_access_token', to: 'refresher#access_token' , as: :refresh_access
      end
    end
  end

  resources :lead_signups, only: [:new, :create]
  resources :voter_signups, only: [:new, :create]

  resources :playlist, only: [:show] do
    resources :vote, only: [:update]
  end

  resources :spotify do
    get :search, to: 'spotify#search'
    post :suggest, on: :member
  end

  get '/spotify_callback', to: 'callback#spotify_callback', as: :spotify_callback
end
