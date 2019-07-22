# This is a controller for employees
# It should create a employee
class EmployeesController < ApplicationController
  def index
    @company = Company.find(1)
    @employee = @company.employees.create(email: 'ayishmaziz@7vals.com', password: 'ishi')
    session[:current_employee_id] = @employee.id
    session[:current_company_id] = @company.id
    session[:is_admin] = true
  end
end
