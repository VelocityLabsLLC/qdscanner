Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    get 'change_plan', :to => 'users/registrations#change_plan'
    put 'change_plan', :to => 'users/registrations#change_plan'
    patch 'change_plan', :to => 'users/registrations#change_plan'
    get 'update_cc', :to => 'users/registrations#update_cc'
  end
  get 'about', to: 'pages#about'
  get 'plans', to: 'pages#plans'
  resources :contacts, only: :create
  get 'contact-us', to: 'contacts#new', as: 'new_contact'
  
  
  resources :users do
    resource :profile
  end
  
  resources :groups do
    member do
      patch :add_user
      put :add_user
      delete :remove_user
    end
  end
  
  resources :organizations do
    member do
      patch :add_user
      put :add_user
      delete :remove_user
    end
  end
end
