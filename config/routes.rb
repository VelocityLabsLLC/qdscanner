Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users, controllers: { registrations: 'users/registrations' }

  get 'about', to: 'pages#about'
  get 'plans', to: 'pages#plans'
  resources :contacts, only: :create
  get 'contact-us', to: 'contacts#new', as: 'new_contact'
  
  
  resources :users, param: :user_id
  resources :users, only: [] do
    resource :profile
    put :cancel_plan
    patch :cancel_plan
    put :update_payment
    patch :update_payment
    put :destroy_card
    patch :destroy_card
    get 'edit_payment', :to => 'users#edit_payment'
  end
  
  resources :groups, param: :group_id
  
  resources :groups, only: [] do
    resources :animals, param: :animal_id
  end
  
  resources :groups, only: [], param: :group_id do 
    member do
      patch :add_user
      put :add_user
      delete :remove_user
    end
  end
  
  resources :organizations, param: :organization_id do
    member do
      patch :add_user
      put :add_user
      delete :remove_user
    end
  end
end
