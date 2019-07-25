Rails.application.routes.draw do
  resources :departments
  devise_for :employees
  resources :teams
  get 'employee_lists' => 'employees#employees_lists'
  get 'menus/index' => 'menus#index'
  get 'menus/new' => 'menus#new'
  root 'menus#index'

  get '/employees/team_member_render_view' => 'employees#team_member_render_view'
  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee
end
