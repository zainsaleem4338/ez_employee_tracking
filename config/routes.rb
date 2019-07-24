Rails.application.routes.draw do
  devise_for :employees, controllers: { sessions: 'sessions' }
  get 'menus/index' => 'menus#index'
  get 'menus/new' => 'menus#new'
  get 'menus/home' => 'menus#home'
  root 'menus#home'

  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee

  get '/messages/index' => 'messages#index'
  post '/messages/' => 'messages#create'
end
