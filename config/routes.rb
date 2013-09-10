Timesheets::Application.routes.draw do

  resources :roles

  devise_for :users

  get 'users/utilizations/:month' => 'users#utilizations', :as => :utilizations
  resources :users do
    get 'cw/:year/:week/projects', :action => :projects, :constraints => {:year => /[0-9|]+/, :week => /[0-9|]+/}, :as => :projects
  end

  get 'timesheets/new_multiple' => 'timesheets#new_multiple', :as => :new_multiple_timesheets
  post 'timesheets/create_multiple' => 'timesheets#create_multiple', :as => :create_multiple_timesheets
  resources :timesheets
  get 'timesheets/cw/:year/:week' => 'timesheets#weekly', :as => :weekly_timesheets

  resources :projects do
    resources :tasks
  end
  get 'projects/:id/planning/:month' => 'projects#planning', :as => :planning_project
  post 'projects/:id/planning/:month' => 'projects#save_planning'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root :to => 'timesheets#weekly', :year => Date.today.year, :week => Date.today.cweek

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
