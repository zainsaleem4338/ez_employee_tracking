Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  devise_for :employees, controllers: { sessions: 'sessions' }
  resources :teams
  resources :departments
  resources :attendances 
  get 'menus/index' => 'menus#index'
  get 'menus/new' => 'menus#new'
  get 'menus/home' => 'menus#home'
  post 'menus/home' => 'menus#home'
  post 'menus/search_email' => 'menus#search_email'
  root 'menus#home'

  get 'employee_lists' => 'employees#employees_lists'
  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  get '/employees/show' => 'employees#show', :as => :show_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee

  get '/messages/index' => 'messages#index'
  post '/messages/' => 'messages#create'
  get 'employee/attendance' => 'attendances#create', as: :employee_attendance
  get 'employee/attendance/update' => 'attendances#update', as: :update_attendance
end
