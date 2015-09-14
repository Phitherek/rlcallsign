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
  post '/query', to: "main#query"
  post '/api/query', to: "api#query"
  post '/api/specific_query', to: "api#specific_query"
  post '/api/update_current_qth', to: "api#update_current_qth"
  post '/api/user_callsign_info', to: "api#user_callsign_info"
  get '/show', to: "main#show"
  get '/new', to: "main#new"
  post '/create', to: "main#create"
  get '/edit', to: "main#edit"
  put '/update', to: "main#update"
  get '/predestroy', to: "main#predestroy"
  delete '/destroy', to: "main#destroy"
  get '/auth/:provider/callback', to: "main#omniauth_callback", as: :omniauth_callback
  get '/logout', to: "main#logout"

  root to: "main#index"
end
