class EmployeesController < ApplicationController
  def signin
    # # binding.pry 
 end

  def after_signin
    # binding.pry
    @employee = Employee.find_by(email: params[:email])
    if @employee.nil?
      render 'signin'
    else
      redirect_to projects_page_url(@employee)
    end
  end


  def employees_list
    @employees = Employee.order(:email)

    respond_to do |format|

      # binding.pry
      # format.json { render json: @employees.where('name != ? AND department_id = AND name like ?', 'Admin', dept, "%#{params[:term]}%") }
      format.json { render json: Employee.where('role != ? AND name like ?', 'admin',"%#{params[:q]}%" ) }
    end
  end
end
