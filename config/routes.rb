Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get 'about', to: 'pages#about'
  resources :contacts, only: :create
  get 'contact-us', to: 'contacts#new', as: 'new_contact'
  
  resources :users do
    resource :profile
  end
  
  resources :invites
  get 'invite', to: 'group_membership#edit'
  resources :groups
end
