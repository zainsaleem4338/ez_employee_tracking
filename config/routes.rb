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

  get 'employees/:id/projects' => 'projects#index', as: :projects_page

  get 'employee/attendance' => 'attendances#create', as: :employee_attendance
  get 'employee/attendance/update' => 'attendances#update', as: :update_attendance
end
