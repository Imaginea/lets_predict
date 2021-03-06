LetsPredict::Application.routes.draw do

  resources :sessions
  resources :users, :only => [:show,:update] do
    collection do
      get :leaderboard
      get :location_change
    end
  end

  resources :predictions do
    collection do
      get :predict
      get :users_playing
    end
  end

  resources :tournaments

  resources :matches do
    collection  do
      get :statistics
      get :update_results
      get :correct_predictors
    end
  end

  resources :custom_groups, :path => '/groups' do
    member do
      get :waiting_list
    end
    collection do
      get :new_groups
      get :new_invite
      post :create_invite
      post :cancel_invite
      get :reject_invite
      get :accept_invite
      get :delete_group
    end
  end

  resources :group_connections do
    collection do
      get :join_req
    end
    member do
      get :user_disconnect
      get :accept_invitation
      get :ignore_invitation
      get :owner_reminder
    end
  end
  
  match '/invitations' => "users#invitations", :as => :user_invitations
  match '/home' => 'users#show'
  get "signout" => "sessions#destroy", :as => "signout"

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
  root :to => 'sessions#new'

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id))(.:format)'
end
