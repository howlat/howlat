Howlat::Application.routes.draw do

  get "user_preferences/edit"
  get "user_preferences/update"
  root :to => "home#index"

  # Authorization / Session management

  #get "login" => "sessions#new", as: :login
  delete "logout" => "sessions#destroy", as: :logout
  #get "signup" => "users#new", as: :signup

  match "auth/:provider/callback" => 'oauths#callback', via: [:get, :post]
  post "auth/:provider/signup" => "oauths#signup"
  get 'auth/failure' => 'oauths#failure'

  resources :sessions, only: :destroy #[:new, :create, :destroy]
  resources :password_resets, only: [:new, :edit, :create, :update], path: 'password-reset'

  # App Domain
  resources :users, except: [:new, :create] do
    resources :identities, only: [:index, :destroy]
    resource :password, only: [:update]
    resource :profile, only: [:show, :edit, :update]
    resource :preferences, only: [:show, :edit, :update]
  end

  resources :rooms do
    concern :repository_connectable do
      member do
        patch :connect
        delete :disconnect
      end
    end
    resource :repository, concerns: :repository_connectable
    namespace :repositories do
      resources :github_repositories, path: 'github', concerns: :repository_connectable
    end
  end
  resources :accounts do
    resources :rooms
  end

  # resources :accounts do
  #   resources :members
  #   resources :rooms do
  #     resources :messages
  #     resources :invitations, only: [:new, :create, :destroy] do
  #       post :resend, on: :member
  #     end
  #     resources :integrations, only: :index
  #     namespace :integrations do
  #       resources :githubs, path: 'github'
  #     end
  #     delete :leave, on: :member
  #     resource :repository, only: [] do
  #       post :connect, :disconnect, on: :member
  #     end
  #     namespace :repositories, module: nil do
  #       resource :github , controller: 'repositories'
  #     end
  #   end
  # end

  get 'invitations/:token' => 'invitations#accept', :as => 'accept_invitation'

  # App REST API

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resource :bootstrap
      resources :rooms, only: [] do
        member do
          put :hide
        end
        namespace :messages, module: nil do
          resources :threads, only: :show
          resources :contexts, only: :show
        end
        resources :messages do
          collection do
            get 'search/(:query)', as: :search, action: :search
          end
          resources :tags, only: [:create, :destroy], param: :name,
            controller: 'messages/tags'
        end
        resources :members, only: [:index, :show], controller: 'rooms/members'
        resources :tags, only: :index, controller: 'rooms/tags'
      end
      namespace :github do
        resource :callback, only: :create
        resources :repositories , only: :index do
          collection do
            get :search
            get :starred
            get :private
            get :public
            get '*name/events', as: :events, action: :events, constraints: {
              name: Repository::NAME_FORMAT }
          end
        end
      end
    end
  end

  # WILDCARD ROUTES
  get ':name' => 'users#show', name: /[\w\-\.]+/
  get '*name' => 'rooms#show', as: :room_friendly, constraints: {
    name: Room::NAME_FORMAT }
  get '*name/badge' => 'badges#show', as: :room_badge, constraints: {
    name: Room::NAME_FORMAT }



end
