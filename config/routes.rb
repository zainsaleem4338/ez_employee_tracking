Rails.application.routes.draw do
  root 'menus#index'
  resources :departments do
    resources :teams
  end
  resources :attendances

  resources :projects do
    resources :tasks do
      member do
        get 'edit_status'
        patch 'update_status'
      end
    end
  end
  devise_for :employees
  get 'task_report' => 'reports#task_report'
  get 'task_pdf_report' => 'reports#task_pdf_report'
  get '/reports/load_task_data_in_report' => 'reports#load_task_data_in_report'
  get 'employee_lists' => 'employees#employees_lists'
  get 'menus/index' => 'menus#index'
  get 'menus/new' => 'menus#new'
  get '/employees/team_member_render_view' => 'employees#team_member_render_view'
  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  get '/employees/show' => 'employees#show', :as => :show_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee

  get 'teamslist' => 'teams#teams_list'

  get 'employees/:id/projects' => 'projects#index', as: :projects_page

  get 'employee/attendance' => 'attendances#create', as: :employee_attendance
  get 'employee/attendance/update' => 'attendances#update', as: :update_attendance

  resources :reports
end
