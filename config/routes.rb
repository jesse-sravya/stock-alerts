Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users
  
  get "alerts/all" => "alerts#all"
  resources :alerts, except: [:update]

  post "/auth/login", to: "authentication#login"
end
