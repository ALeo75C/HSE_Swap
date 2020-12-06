Rails.application.routes.draw do
  default_url_options host: "localhost:3000"
  namespace :api do
    resources :minors, only: [:show, :index]
    # get 'minors/index'
    # get 'minors/show'
  end

  resources :minors
  get 'welcome/index'
  root 'minors#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
