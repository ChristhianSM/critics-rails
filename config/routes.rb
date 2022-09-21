Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: :callbacks }
  # Defines the root path route ("/")
  root "games#index"
  resources "users"
  resources "games" do
    resources "critics"
  end
  resources "genres"
  resources "platforms"
  resources "companies" do
    resources "critics"
  end
  resources "critics"

  # Routes critics
  get "/approved_critic", to: "critics#approve", as: "approve_critic"

  get "/games_involved_companies/destroy_involved_company", to: "companies#destroy_involved_company", as: "destroy_involved_company"
  post "/games_companies/create_involved_company", to: "companies#create_involved_company", as: "create_involved_company"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
