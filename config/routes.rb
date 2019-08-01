Rails.application.routes.draw do
  root 'menus#index'

  resources :teams
  resources :departments
  resources :attendances

  resources :projects do
    resources :tasks do
      member do
        get 'edit_status'
        patch 'update_status'
      end
    end
  end

  resources :tasks, only: [:my_tasks, :update_task_logtime]
  devise_for :employees

  get 'menus/index' => 'menus#index'
  get 'menus/new' => 'menus#new'

  get 'employees/export_report' => 'employees#pdf_velocity_report', as: :pdf_velocity_report

  get 'my_tasks' => 'tasks#my_tasks', :as => :employee_tasks_list
  patch 'tasks/:id/update_task_logtime' => 'tasks#update_task_logtime', :as => :update_task_logtime
  get 'employee_lists' => 'employees#employees_lists'
  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  get '/employees/:id/show' => 'employees#show', :as => :show_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee

  get 'employee_lists' => 'employees#employees_lists'

  get 'teamslist' => 'teams#teams_list'

  get 'employees/:id/projects' => 'projects#index', as: :projects_page

  get 'employee/attendance' => 'attendances#create', as: :employee_attendance
  get 'employee/attendance/update' => 'attendances#update', as: :update_attendance
end
