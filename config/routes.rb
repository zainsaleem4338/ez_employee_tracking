Rails.application.routes.draw do
  devise_for :employees, controllers: { sessions: 'sessions' }

  resources :attendances
  resources :settings, except: [:create, :edit, :update, :show, :destroy]
  post '/settings/create' => 'settings#create', as: :create_settings
  get '/settings/edit' => 'settings#edit', as: :edit_settings
  patch '/settings/update' => 'settings#update', as: :update_settings

  get '/events/index' => 'events#index', as: :index_events
  get '/events/new' => 'events#new', as: :new_events
  get '/events/home' => 'events#home', as: :home_events
  post '/events/create' => 'events#create', as: :create_events
  get '/events/:id/edit' => 'events#edit', as: :edit_events
  patch '/events/:id/update' => 'events#update', as: :update_events
  delete '/events/:id/destroy' => 'events#destroy', as: :destroy_events

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
  post 'menus/home' => 'menus#home'
  post 'menus/search_email' => 'menus#search_email'
  root 'menus#home'

  get 'reports/velocity' => 'reports#show', as: :show_employee_velocity_report
  get 'reports/export_report' => 'reports#pdf_velocity_report', as: :pdf_velocity_report
  get 'employees_attendance_report' => 'reports#attendance_report'
  get 'employees_report_pdf' => 'reports#attendance_report_pdf'

  get 'employee_tasks' => 'tasks#employee_tasks', :as => :employee_tasks_list
  patch 'tasks/:id/update_task_logtime' => 'tasks#update_task_logtime', :as => :update_task_logtime
  get 'employee_lists' => 'employees#employees_lists'
  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  get '/employees/:sequence_num/show' => 'employees#show', :as => :show_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee

  get '/messages/index' => 'messages#index'
  post '/messages/' => 'messages#create'

  get 'employees_attendance_report' => 'reports#attendance_report'
  get 'employees_report_pdf' => 'reports#attendance_report_pdf'

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
