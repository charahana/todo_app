Rails.application.routes.draw do
  devise_for :users
  resources :tasks, only: [:new, :create, :index, :show, :edit, :update, :destroy]
  resources :users, only: [:show, :edit, :update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end
  unauthenticated do
    root to: 'homes#top'
  end
  get '/about', to: 'homes#about', as: 'about'
end
