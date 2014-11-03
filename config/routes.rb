Brimir::Application.routes.draw do


  namespace :api do
  namespace :v1 do
    get 'add_ticket/index'
    end
  end

  namespace :api do
  namespace :v1 do
    post 'add_ticket/add'
    post 'sessions/create'
    post 'tickets/add'
    end
  end



  devise_for :users

  resources :users

  resources :tickets, only: [:index, :show, :update, :new, :create]

  resources :labelings, only: [:destroy, :create]

  resources :rules

  resources :replies, only: [:create, :new]
  get '/attachments/:id/:format' => 'attachments#show'

  root :to => 'tickets#index'

=begin
  namespace :api do
    namespace :v1 do
      resources :tickets, only: [ :index, :show ]
      resources :sessions, only: [ :create ]
    end
  end
=end
end
