Rails.application.routes.draw do
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

  namespace :api do
    namespace :v1 do
      get 'ping' => 'base#ping'
      get 'test_airbrake' => 'base#test_airbrake'

      mount_devise_token_auth_for 'User', at: 'api/v1/users'

      resources :users, only: [] do
        member do
          get :list_orgas, path: 'orgas'
        end
      end


      resources :orgas do
        member do
          post :create_member, path: 'users'
          put :add_member, path: 'users/:user_id'
          delete :remove_member, path: 'users/:user_id'
          put :promote_member, path: 'users/:user_id/promote'
          put :demote_admin, path: 'users/:user_id/demote'
        end
      end
    end

    # namespace :v2 do
    #   get 'ping' => 'api#ping'
    #   get 'test_airbrake' => 'api#test_airbrake'
    #
    #   mount_devise_token_auth_for 'User', at: 'api/v2/users'
    #   # resources :users
    # end
  end

end
