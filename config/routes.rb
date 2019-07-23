Rails.application.routes.draw do

    # get 'projects/resources'




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
  devise_for :employees
  get 'menus/index' => 'menus#index'
  get 'menus/new' => 'menus#new'
  root 'menus#index'

  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee

  resources :projects
  
  get 'signin' => 'employees#signin'
  post 'signin_url' => 'employees#after_signin'

  get 'employeeslist' => 'employees#employees_list'
  get 'teamslist' => 'teams#teams_list'
  get 'project/:id/new_task' => 'tasks#new', as: :new_task_page
  get 'projects/:id/tasks' => 'tasks#index', as: :tasks_page
  get 'employees/:id/projects' => 'projects#index', as: :projects_page
  get 'projects/:id/tasks/:id' => "tasks#edit", as: :edit_a_task_page
  patch 'projects/:id/tasks/:id' => "tasks#update", as: :update_a_task_page

  resources :tasks
end
