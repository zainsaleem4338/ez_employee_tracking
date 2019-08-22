class TasksController < ApplicationController
  load_and_authorize_resource only: [:employee_tasks, :update_task_logtime]
  load_and_authorize_resource :department
  load_and_authorize_resource :project, through: :department, except: [:employee_tasks, :update_task_logtime]
  load_and_authorize_resource :task, through: :project, except: [:employee_tasks, :update_task_logtime]

  # get /departments/:department_id/projects/:project_id/tasks
  def index
    if params[:show_employees_only].present? && current_employee.role != Employee::ADMIN_ROLE
      @tasks = @tasks.get_employee_tasks(current_employee)
    end
    @tasks = @tasks.paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
    end
  end

  # post /departments/:department_id/projects/:project_id/tasks
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
      render :new
    end
  end

  # patch /departments/:department_id/projects/:project_id/tasks/:id
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
        rrender :new
      end
    end
  end

  # delete /departments/:department_id/projects/:project_id/tasks/:id
  def destroy
    @task.destroy
    if @task.destroyed?
      flash[:success] = t('.success_notice')
    else
      flash[:danger] = t('.error_notice')
    end
    redirect_to department_project_tasks_path
  end

  # patch /departments/:department_id/projects/:project_id/tasks/:id/update_status
  def update_status
    if @task.update_attribute('status', task_params[:status])
      flash[:success] = t('.success_notice')
    else
      flash[:danger] = t('.error_notice')
    end
    redirect_to department_project_tasks_path
  end

  # patch /tasks/:id/update_task_logtime
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
