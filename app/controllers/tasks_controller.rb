class TasksController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :task, through: :project

  def create
    @task.set_status
    if @task.save
      redirect_to project_tasks_url(@task.project), notice: t('.success_notice')
    else
      render new_project_task_path(@task.project), notice: t('.error_notice')
    end
  end

  def update
    if !params[:assignable_employee_id].empty? && !params[:assignable_team_id].empty?
      render :edit, notice: t('.error_field_notice')
    else
      params[:task][:status] = 'new' if params[:task][:assignable_id].empty?
      params[:task][:status] = 'assigned' unless params[:task][:assignable_id].empty?
      if @task.update(task_params)
        redirect_to project_tasks_path, notice: t('.success_notice')
      else
        redirect_to project_tasks_path, notice: t('.error_notice')
      end
    end
  end

  def destroy
    @task.destroy
    if @task.destroyed?
      redirect_to project_tasks_path, notice: t('.success_notice')
    else
      redirect_to project_tasks_path, notice: t('.error_notice')
    end
  end

  def update_status
    if @task.update(task_params)
      redirect_to project_tasks_path, notice: t('.success_notice')
    else
      redirect_to project_tasks_path, notice: t('.error_notice')
    end
  end

  private

  def task_params
    params.require(:task).
      permit(:company_id, :start_date, :expected_end_date, :description, :name, :project_id, :status, :assignable_type, :assignable_id)
  end
end
