Rails.application.routes.draw do
      
  # get 'home/index'
  get '/autocomplete', to: 'home#autocomplete'

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  resources :authors, :concerns => :paginatable do
    resources :awards, only: [:create, :edit, :update, :destroy]
  end
  resources :awards, only: [:index], :concerns => :paginatable 

  resources :prizes, :books, :contributions, :concerns => :paginatable
  
  resources :publishers, :concerns => :paginatable do
    resources :places, only: [:create, :edit, :update, :destroy]
    collection do
      get 'search'
    end
  end 
  
  # get 'import/index'
  get 'import', to: 'import#index'
  # post 'import', to: 'import#upload'
  post 'import/url', to: 'import#import_from_url'
  post 'import/text', to: 'import#import_from_text'
  post 'import/file', to: 'import#import_from_file'

  resources :categories

  devise_for :users  

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
