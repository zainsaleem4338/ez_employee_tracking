Rails.application.routes.draw do
  devise_for :employees, controllers: { sessions: 'sessions' }

  resources :attendances

  resources :departments do
    resources :teams
    resources :projects do
      resources :tasks do
        member do
          get 'edit_status'
          patch 'update_status'
        end
      end
    end
  end
  resources :tasks, only: [:employee_tasks, :update_task_logtime]

  get 'menus/index' => 'menus#index'
  get 'menus/new' => 'menus#new'
  get 'menus/home' => 'menus#home'
  root 'menus#home'

  get 'reports/velocity' => 'reports#show', as: :show_employee_velocity_report
  get 'reports/export_report' => 'reports#pdf_velocity_report', as: :pdf_velocity_report
  get 'employee_tasks' => 'tasks#employee_tasks', :as => :employee_tasks_list
  patch 'tasks/:id/update_task_logtime' => 'tasks#update_task_logtime', :as => :update_task_logtime
  get 'employee_lists' => 'employees#employees_lists'
  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  get '/employees/:sequence_num/show' => 'employees#show', :as => :show_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee
  get 'employee_lists' => 'employees#employees_lists'
  get '/employees/team_member_render_view' => 'employees#team_member_render_view'

  get 'employees/:id/projects' => 'projects#index', as: :projects_page

  get 'employee/attendance' => 'attendances#create', as: :employee_attendance
  get 'employee/attendance/update' => 'attendances#update', as: :update_attendance

  resources :reports do
    collection do
      get 'load_task_data_in_report' => 'reports#load_task_data_in_report'
      get 'task_report' => 'reports#task_report'
      get 'task_pdf_csv_report' => 'reports#task_pdf_csv_report'
    end
  end
  get 'teamslist' => 'teams#teams_list'
end
