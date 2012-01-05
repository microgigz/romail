Romail::Application.routes.draw do
#  get "admin/index"
#
#  get "users/login"
#
#  get "messages/index"

  match 'messages/index/:folder', :to => 'messages#index'

  match 'users/login', :to => 'users#login'

  match 'messages/movemesgs', :to => 'messages#movemesgs'

  match 'messages/show/:id/:folder', :to => 'messages#show'

  match 'messages/destroy/:id/:folder', :to => 'messages#destroy'

  match 'messages/settings', :to => 'messages#settings'

  match 'messages/logout', :to => 'users#logout'

  match 'messages/sub_unsub/:folder', :to => 'messages#sub_unsub'

  match 'messages/new', :to => 'messages#new'

  match 'messages/savedraft', :to => 'messages#savedraft'

  match '/admin', :to => 'admin#index'

  match '/admin/login', :to => 'admin#login'

  match '/admin/index', :to => 'admin#index'

  match '/admin/home', :to => 'admin#home'

  match '/admin/destroy', :to => 'admin#destroy'

  match '/admin/active_inactive/:id', :to => 'admin#active_inactive'

  match '/admin/delete_domain/:id', :to => 'admin#delete_domain'

  match '/admin/add_domain', :to => 'admin#add_domain'

  match '/admin/edit_domain', :to => 'admin#edit_domain'

  match '/admin/profile', :to => 'admin#profile'

  match '/admin/view_profile', :to => 'admin#view_profile'

  match '/admin/update_profile', :to => 'admin#update_profile'

  match '/admin/reset_password', :to => 'admin#reset_password'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "messages#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  #  match ':controller(/:action(/:id(.:format)))'
end
