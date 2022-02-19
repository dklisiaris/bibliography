Rails.application.routes.default_url_options[:host] = (Rails.env == 'production' || Rails.env == 'staging') ? 'bibliography.gr' : 'localhost:3000'
Rails.application.routes.draw do

  get 'pages/welcome_guide'
  get 'pages/privacy-policy'
  get 'pages/about'
  get 'pages/contact'

  resources :shelves

  # resources :profiles, only: [:show, :edit, :update]

  # get 'home/index'
  get '/autocomplete', to: 'home#autocomplete'
  get '/search', to: 'home#search'

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  resources :authors, :concerns => :paginatable do
    resources :awards, only: [:create, :edit, :update, :destroy]
    member do
      post 'favourite'
    end
  end
  resources :awards, only: [:index], :concerns => :paginatable

  resources :prizes, :contributions, :concerns => :paginatable

  resources :books, :concerns => :paginatable do
    member do
      get 'collections'
      post 'collections', to: 'books#manage_collections'
      post 'like'
      post 'dislike'
    end
    collection do
      get 'my'
      get 'featured'
      get 'trending'
      get 'awarded'
      get 'latest'
    end
  end

  resources :publishers, :concerns => :paginatable do
    resources :places, only: [:create, :edit, :update, :destroy]
    collection do
      get 'search'
    end
  end

  resources :series, only: [:index], :concerns => :paginatable

  # resource :profile, only: [:update]
  # get "profile/:id", :to => "profiles#show", as: 'user_profile'
  resource :profile, only: [:edit, :update]
  get "library/(:id)", :to => "profiles#show", as: 'public_profile'
  post "library/(:id)/follow", :to => "profiles#follow"

  get "library/(:id)/shelves/(:shelf_id)", :to => "shelves#public_shelves", as: 'public_shelf'
  get "library/(:id)/shelves", :to => "shelves#public_shelves", as: 'public_shelves'

  # get "profile/edit", :to => "profile#edit", as: 'edit_profile'
  # patch "profile", :to => "profile#update", as: 'update_profile'
  # get '/:permalink',      to: 'users#show', as: 'custom_user'
  # get 'profile/:id', to: 'profiles#show'

  ##
  # Import Controller Routes
  #
  get 'import', to: 'import#index', as: :import
  # post 'import', to: 'import#upload'
  post 'import/url', to: 'import#import_from_url'
  post 'import/text', to: 'import#import_from_text'
  post 'import/file', to: 'import#import_from_file'

  get "import/storage", to: 'import#import_from_storage', as: :storage_import

  ##
  # Tasks Controller Routes
  #
  get 'tasks', to: 'tasks#index', as: :tasks

  get 'tasks/update', to: 'tasks#update_content'
  get 'tasks/import_botd_candidates', to: 'tasks#import_book_of_the_day_candidates'

  resources :categories do
    member do
      post 'favourite'
    end
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", registrations: 'users/registrations' }

  authenticate :user, lambda { |u| u.role == 'admin' } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
    mount RedisBrowser::Web => '/redis'
  end

  # Restful API routes
  namespace :api do
    namespace :v1 do
      resources :books, only: [:index, :show] do
        collection do
          get 'my'
          get 'rated_ids'
        end
        resources :comments, except: [:new, :edit]
      end
      resources :authors, only: [:index, :show]
      resources :publishers, only: [:show]
      resources :categories, only: [:index, :show] do
        collection do
          get 'liked_with_books'
        end
      end
      resources :series, only: [:show]
      resources :sessions, only: [:create]
      post 'authenticate', to: 'sessions#create'
    end
  end

  root to: 'home#index'
end
