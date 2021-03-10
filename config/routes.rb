Rails.application.routes.draw do
  root 'candidates#search'
  resources :candidates, only: [:index] do
    collection do 
      get :search
    end
  end
end
