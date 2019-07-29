class EmployeesController < ApplicationController
  load_and_authorize_resource :employee, through_association: :company

  def employees_lists
    respond_to do |format|
      format.json { render json: @employees.where('role != ? AND name like ?', Employee::ADMIN_ROLE, "%#{params[:q]}%") }
    end
  end

  def create
    if @employee.save
      flash.now[:success] = 'Employee successfully created!'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    @employee = current_employee.company.employees
                                .find_by(sequence_num: params[:id])
    @employee.active = false
    flash[:danger] = 'Employee is now inactive!'
    if @employee.save
      redirect_to employees_path
    else
      redirect_to root_path
    end
  end

  private

  def employee_params
    params.require(:employee)
          .permit(:name, :email, :password, :role, :company_id, :department_id)
  end
end
