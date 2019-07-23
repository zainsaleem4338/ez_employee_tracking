Rails.application.routes.draw do
  
  root 'menus#index'

  get 'employee_lists' => 'employees#employees_lists'
  resources :teams
  resources :departments
  resources :projects
  resources :tasks
  devise_for :employees

  get 'menus/index' => 'menus#index'
  get 'menus/new' => 'menus#new'

  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee

  get 'employeeslist' => 'employees#employees_list'

  get 'teamslist' => 'teams#teams_list'

  get 'project/:id/new_task' => 'tasks#new', as: :new_task_page
  get 'projects/:id/tasks' => 'tasks#index', as: :tasks_page
  get 'projects/:id/tasks/:id' => "tasks#edit", as: :edit_a_task_page
  patch 'projects/:id/tasks/:id' => "tasks#update", as: :update_a_task_page

  get 'employees/:id/projects' => 'projects#index', as: :projects_page

end
