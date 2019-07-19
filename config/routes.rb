Rails.application.routes.draw do
  devise_for :employees
  get 'menus/index' => 'menus#index'
  get 'menus/new' => 'menus#new'
  root 'menus#index'

  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee
end
