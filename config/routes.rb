Rails.application.routes.draw do
  devise_for :users
  root "pages#index"

  get 'search', to: "pages#search"
  resources :reviewers do
    resources :reviews
  end
end
