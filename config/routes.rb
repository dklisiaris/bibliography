Rails.application.routes.default_url_options[:host] = (Rails.env == 'production' || Rails.env == 'staging') ? 'bibliography.gr' : 'localhost:3000'
Rails.application.routes.draw do

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
    end
  end

  resources :publishers, :concerns => :paginatable do
    resources :places, only: [:create, :edit, :update, :destroy]
    collection do
      get 'search'
    end
  end


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

  resources :categories do
    member do
      post 'favourite'
    end
  end

  devise_for :users

  authenticate :user, lambda { |u| u.admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end


  # Restful API routes
  namespace :api do
    namespace :v1 do
      resources :books, only: [:index, :show] do
        collection do
          get 'my'
        end
        resources :comments, except: [:new, :edit]
      end
      resources :authors, only: [:index, :show]
      resources :publishers, only: [:show]
      resources :categories, only: [:show]
      resources :sessions, only: [:create]
      post 'authenticate', to: 'sessions#create'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
