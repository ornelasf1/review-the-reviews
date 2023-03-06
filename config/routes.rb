Rails.application.routes.draw do
  root "pages#index"
  
  # get 'reviewers/:category', to: "reviewers#index"
  # get 'reviewers/:category/:id', to: "reviewers#show"

  get 'search', to: "pages#search"
  resources :reviewers do
    resources :reviews
  end
end
