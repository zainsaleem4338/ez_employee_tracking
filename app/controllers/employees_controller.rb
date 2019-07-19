class EmployeesController < ApplicationController
  def index
    @employees = current_employee.company.employees.active_members
  end

  def new
    @employee = current_employee.company.employees.new
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.password = generate_password
    if @employee.save
      flash[:success] = 'Employee successfully created!'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    @employee = current_employee.company.employees.find_by(sequence_num: params[:id])
    @employee.active = false
    flash[:danger] = 'Employee is now inactive!'
    if @employee.save
      redirect_to employees_path
    else
      redirect_to root_path
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :email, :password, :role, :company_id, :department_id)
  end

  def generate_password
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...10).map { o[rand(o.length)] }.join
  end
end
