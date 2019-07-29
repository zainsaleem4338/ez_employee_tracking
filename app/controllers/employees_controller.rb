class EmployeesController < ApplicationController

  def index
    @employees = current_employee.company.employees.active_members
  end

  def employees_list
    if params['department'].nil?
      @employees = current_employee.company.employees.active_members.order(:name)
    else
      @employees = current_employee.company.departments.find(params['department'].to_i).employees.active_members.order(:name)
    end
    respond_to do |format|
      format.json { render json: @employees.where('role != ? AND name like ?', Employee::ADMIN_ROLE, "%#{params[:term]}%") }
    end
  end

  def new
    @employee = current_employee.company.employees.new
  end

  def show
    @employee = Employee.find(current_employee.id)
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      flash.now[:success] = 'Employee successfully created!'
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
  end

  def team_member_render_view
    @team_members = Employee.where(id: params['employee_ids'])
    @count = params['count']
    respond_to do |format|
      format.js
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :email, :password, :role, :company_id, :department_id, :avatar)
  end
end
