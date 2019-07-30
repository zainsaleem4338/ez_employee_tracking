class TasksController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :task, through: :project

  def create
    @task.set_status
    if @task.save
      redirect_to project_tasks_url(@task.project), notice: "Task created successfully!"
    else
      redirect_to new_project_task_path(@task.project), notice: "Task cannot be created!"
    end
  end

  def update
    if !params[:assignable_employee_id].empty? && !params[:assignable_team_id].empty?
      render :edit, notice: "Make sure you delete employee field or team field"
    else
      params[:task][:status] = Task::NEW_STATUS if params[:task][:assignable_id].empty?
      params[:task][:status] = Task::ASSIGNED_STATUS if !params[:task][:assignable_id].empty?
      if @task.update(task_params)
        redirect_to project_tasks_path, notice: "Task updated successfully!"
      else
        redirect_to project_tasks_path, notice: "Task cannot be updated!"
      end
    end
  end

  def destroy
    @task.destroy
    if @task.destroyed?
      redirect_to project_tasks_path, notice: "Deleted Successfully"
    else
      redirect_to project_tasks_path, notice: "Cannot be deleted successfully"
    end
  end

  def update_status
    if @task.update(task_params)
      redirect_to project_tasks_path, notice: "Updated Successfully"
    else
      redirect_to project_tasks_path, notice: "Cannot be updated!"
    end
  end

  private

  def task_params
    params.require(:task).
      permit(:company_id, :start_date, :expected_end_date, :description, :name, :project_id, :status, :assignable_type, :assignable_id)
  end

end
