class TasksController < ApplicationController
  load_and_authorize_resource only: [:employee_tasks, :update_task_logtime]
  load_and_authorize_resource :department
  load_and_authorize_resource :project, through: :department, except: [:employee_tasks, :update_task_logtime]
  load_and_authorize_resource :task, through: :project, except: [:employee_tasks, :update_task_logtime]

  def index
    if params[:show_employees_only].present? && current_employee.role != Employee::ADMIN_ROLE
      @tasks = @tasks.get_employee_tasks(current_employee)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @task.set_status
    if @task.save
      if @task.assignable_type == Task::EMPLOYEE
        @task.task_time_logs.create(employee_id: @task.assignable_id)
      elsif @task.assignable_type == Task::TEAM
        @task.assignable.employees.each do |employee|
          @task.task_time_logs.create(employee_id: employee.id)
        end
      end
      flash[:success] = t('.success_notice')
      redirect_to department_project_tasks_path
    else
      flash[:danger] = t('.error_notice')
      redirect_to new_department_project_task_path
    end
  end

  def update
    if params[:assignable_employee_id].present? && params[:assignable_team_id].present?
      flash[:danger] = t('.error_field_notice')
      render :edit
    else
      params[:task][:status] = Task::NEW_STATUS if !params[:task][:assignable_id].present?
      params[:task][:status] = Task::ASSIGNED_STATUS if params[:task][:assignable_id].present?
      if @task.update(task_params)
        flash[:success] = t('.success_notice')
        redirect_to department_project_tasks_path
      else
        flash[:danger] = t('.error_notice')
        redirect_to edit_department_project_task_path
      end
    end
  end

  def destroy
    @task.destroy
    if @task.destroyed?
      flash[:success] = t('.success_notice')
    else
      flash[:danger] = t('.error_notice')
    end
    redirect_to department_project_tasks_path
  end

  def update_status
    if @task.update_attribute('status', task_params[:status])
      flash[:success] = t('.success_notice')
    else
      flash[:danger] = t('.error_notice')
    end
    redirect_to department_project_tasks_path
  end

  def update_task_logtime
    unless params[:task_time_log][:hours].blank?
      @task_log = @task.task_time_logs.find_by(employee_id: current_employee.id, task_id: @task.id)
      @result = @task_log.
        update_attribute('hours', @task_log.hours.to_i + params[:task_time_log][:hours].to_i)
      if @result
        flash.now[:success] = t('.success_notice')
      else
        flash.now[:danger] = t('.error_notice')
      end
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def task_params
    params.require(:task).
      permit(:company_id, :start_date, :expected_end_date, :description, :name, :project_id, :status, :assignable_type, :assignable_id, :complexity, :reviewer_id)
  end
end
