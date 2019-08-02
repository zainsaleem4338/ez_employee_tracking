class TasksController < ApplicationController
  load_and_authorize_resource only: [:my_tasks, :update_task_logtime]
  load_and_authorize_resource :project, except: [:my_tasks, :update_task_logtime]
  load_and_authorize_resource :task, through: :project, except: [:my_tasks, :update_task_logtime]
 
  def create
    @task.set_status
    if @task.save
      flash[:success] = 'Created Task Successfully!'
      redirect_to project_tasks_url(@task.project)
    else
      flash[:danger] = 'Could not create Task!'
      render new_project_task_path(@task.project)
    end
  end

  def update
    if !params[:assignable_employee_id].empty? && !params[:assignable_team_id].empty?
      flash[:danger] = 'Make sure you delete employee field or team field'
      render :edit
    else
      params[:task][:status] = 'new' if params[:task][:assignable_id].empty?
      params[:task][:status] = 'assigned' if !params[:task][:assignable_id].empty?
      if @task.update(task_params)
        flash[:success] = 'Updated Task Successfully!'
        redirect_to project_tasks_path
      else
        flash[:danger] = 'Could not update Task!'
        redirect_to project_tasks_path
      end
    end
  end

  def destroy
    @task.destroy
    if @task.destroyed?
      flash[:success] = 'Deleted Task Successfully!'
      redirect_to project_tasks_path
    else
      flash[:danger] = 'Could not delete Task!'
      redirect_to project_tasks_path
    end
  end

  def update_status
    if @task.update(task_params)
      flash[:success] = 'Updated Task Status Successfully!'
      redirect_to project_tasks_path
    else
      flash[:danger] = 'Could not update Task Status!'
      redirect_to project_tasks_path
    end
  end

  def update_task_logtime
    unless params[:task][:log_time].blank?
      @result = @task.update_attribute('log_time', @task.log_time.to_i + params[:task][:log_time].to_i)
      if @result
        flash.now[:success] = 'Updated task log-time Successfully!'
      else
        flash.now[:danger] = 'Could not update task log-time!'
      end
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def task_params
    params.require(:task).
      permit(:company_id, :start_date, :expected_end_date, :description, :name, :project_id, :status, :assignable_type, :assignable_id, :complexity)
  end
end
