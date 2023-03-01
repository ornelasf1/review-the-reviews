Rails.application.routes.draw do
  root "pages#index"
  
  get 'reviewers/:category', to: "reviewers#index"
end
