Rails.application.routes.draw do

  get '/my_cruds' => 'display#my_cruds'
  get '/not_authorised' => 'welcome#not_authorised'
  delete '/logout' => 'welcome#session_destroy'

  root 'home#index'
  get '/draw_graph' => 'welcome#draw_graph'
  get '/api/master_reports_count' => 'display#master_reports_count'
  get '/api/cruds_count' => 'display#cruds_count'
  get '/api/user_cruds' => 'display#user_cruds'


  resources :welcome
# root 'welcome#index'
 # root 'display#index'

  post "dbcredentials" => "welcome#dbcredentials"
  get "msttablelisting" => "welcome#msttablelisting"
  get "tablelisting" => "welcome#tablelisting"
  get 'table_info/:table' => "welcome#table_info", :as => :table_info
  #get 'create_crud/:table' => "welcome#create_crud", :as => :create_crud
  post 'create_crud/:table' => "welcome#create_crud", :as => :create_crud
  get 'controller_list' => "welcome#controller_list"
  get 'mst_controller_list' => "welcome#mst_controller_list"
  get '/download_data' => 'display#download_data'
  post 'sign_in' => 'home#sign_in'

  resources :display 
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
#  root 'display#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
