class EmployeesController < ApplicationController
  STATUS = { 'PRESENT': 1, 'ABSENT': 0 }.freeze
  load_and_authorize_resource :employee, through_association: :company

  def employees_lists
    respond_to do |format|
      format.json { render json: @employees.where('role != ? AND name like ?', Employee::ADMIN_ROLE, "%#{params[:q]}%") }
    end
  end

  def show
    @attendances_list = current_employee.company.attendances.where(status: STATUS[:PRESENT]).order(login_time: :desc)
    
    @tasks_of_employee = Task.get_employee_tasks(current_employee)
    @total_time_on_tasks = time_spent_on_tasks(@tasks_of_employee)
    @total_task_complexity = compute_total_complexity_of_tasks(@tasks_of_employee)
    @employee_velocity = (@total_task_complexity.to_f / @total_time_on_tasks)
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

  def generate_velocity_report
    
  end

  private

  def employee_params
    params.require(:employee)
          .permit(:name, :email, :password, :role, :company_id, :department_id)
  end

  def compute_total_complexity_of_tasks(employee_tasks)
    @sum_complexity = 0
    employee_tasks.each do |task|
      @sum_complexity += task.complexity
    end
    @sum_complexity
  end

  def time_spent_on_tasks(employee_tasks)
    @time = 0
    employee_tasks.each do |task|
      @time += task.log_time.to_i
    end
    @time
  end
end
