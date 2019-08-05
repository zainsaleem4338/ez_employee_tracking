Rails.application.routes.draw do
  devise_for :employees, controllers: { sessions: 'sessions' }

  resources :teams
  resources :departments
  resources :attendances
  resources :settings, except: [:create, :edit, :update, :show]
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

  resources :projects do
    resources :tasks do
      member do
        get 'edit_status'
        patch 'update_status'
      end
    end
  end

  get 'menus/index' => 'menus#index'
  get 'menus/new' => 'menus#new'
  get 'menus/home' => 'menus#home'
  post 'menus/home' => 'menus#home'
  post 'menus/search_email' => 'menus#search_email'
  root 'menus#home'

  get 'employee_lists' => 'employees#employees_lists'
  get '/employees/index' => 'employees#index', :as => :employees
  get '/employees/new' => 'employees#new', :as => :new_employee
  get '/employees/:id/show' => 'employees#show', :as => :show_employee
  post '/employees/create' => 'employees#create', :as => :create_employee
  delete '/employees/:id' => 'employees#destroy', :as => :delete_employee

  get '/messages/index' => 'messages#index'
  post '/messages/' => 'messages#create'

  get 'employee_lists' => 'employees#employees_lists'

  get 'teamslist' => 'teams#teams_list'

  get 'employees/:id/projects' => 'projects#index', as: :projects_page

  get 'employee/attendance' => 'attendances#create', as: :employee_attendance
  get 'employee/attendance/update' => 'attendances#update', as: :update_attendance
end
