Rails.application.routes.draw do

  root 'menus#index'

  resources :teams
  resources :departments
  resources :projects
  resources :tasks
  resources :attendances


  devise_for :employees

  get 'menus/index' => 'menus#index'
  get 'menus/new' => 'menus#new'

  get 'employee_lists' => 'employees#employees_lists'
  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  get '/employees/show' => 'employees#show', :as => :show_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee

  get 'employee_lists' => 'employees#employees_lists'

  get 'teamslist' => 'teams#teams_list'

  get 'project/:id/new_task' => 'tasks#new', as: :new_task_page
  get 'projects/:id/tasks' => 'tasks#index', as: :tasks_page
  get 'projects/:id/tasks/:id' => "tasks#edit", as: :edit_a_task_page
  patch 'projects/:id/tasks/:id' => "tasks#update", as: :update_a_task_page
  get 'tasks_update_status/:id' => "tasks#update_status", as: :edit_task_status
  patch 'tasks_update_status/:id' => "tasks#update_status", as: :update_task_status


  get 'employees/:id/projects' => 'projects#index', as: :projects_page

  get 'employee/attendance' => 'attendances#create', as: :employee_attendance
  get 'employee/attendance/update' => 'attendances#update', as: :update_attendance
end
