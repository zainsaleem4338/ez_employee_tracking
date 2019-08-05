class TasksController < ApplicationController
  load_and_authorize_resource only: [:employee_tasks, :update_task_logtime]
  load_and_authorize_resource :department
  load_and_authorize_resource :project, through: :department, except: [:employee_tasks, :update_task_logtime]
  load_and_authorize_resource :task, through: :project, except: [:employee_tasks, :update_task_logtime]

  def index
    if params[:show_employees_only].present? && current_employee.role != Employee::ADMIN_ROLE
      @tasks = @tasks.employee_tasks(current_employee)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @task.set_status
    if @task.save
      flash[:success] = 'Created Task Successfully!'
      redirect_to department_project_tasks_path
    else
      flash[:danger] = 'Could not create Task!'
      render new_department_project_task_path
    end
  end

  def update
    if params[:assignable_employee_id].present? && params[:assignable_team_id].present?
      flash[:danger] = 'Make sure you delete employee field or team field'
      render :edit
    else
      params[:task][:status] = Task::NEW_STATUS if !params[:task][:assignable_id].present?
      params[:task][:status] = Task::ASSIGNED_STATUS if params[:task][:assignable_id].present?
      if @task.update(task_params)
        flash[:success] = 'Updated Task Successfully!'
        redirect_to department_project_tasks_path
      else
        flash[:danger] = 'Could not update Task!'
        redirect_to edit_department_project_task_path
      end
    end
  end

  def destroy
    @task.destroy
    if @task.destroyed?
      flash[:success] = 'Deleted Task Successfully!'
      redirect_to department_project_tasks_path
    else
      flash[:danger] = 'Could not delete Task!'
      redirect_to department_project_tasks_path
    end
  end

  def update_status
    if @task.update(task_params)
      flash[:success] = 'Updated Task Status Successfully!'
      redirect_to department_project_tasks_path
    else
      flash[:danger] = 'Could not update Task Status!'
      redirect_to department_project_tasks_path
    end
  end

  def update_task_logtime
    unless params[:task][:log_time].blank?
      @result = @task.update_attribute('log_time', @task.log_time.to_i + params[:task][:log_time].to_i)
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def task_params
    params.require(:task).
      permit(:company_id, :start_date, :expected_end_date, :description, :name, :project_id, :status, :assignable_type, :assignable_id, :reviewer_id)
  end
end
