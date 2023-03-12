Rails.application.routes.draw do
  devise_for :users
  root "pages#index", as: "user"
  
  # get 'reviewers/:category', to: "reviewers#index"
  # get 'reviewers/:category/:id', to: "reviewers#show"

  get 'search', to: "pages#search"
  resources :reviewers do
    resources :reviews
  end
end
