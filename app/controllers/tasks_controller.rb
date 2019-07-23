class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :show]
  before_action :set_task_update, only: [:update, :destroy]

  def index
    if current_employee.role == "Admin"
      @project = current_employee.company.projects.find(params[:id])
    end
  end

  def new
    @task = current_employee.company.projects.find(params[:id]).tasks.new
  end

  def create
    @task = Task.create(tasks_create_params)
    @task.set_status
    if @task.save
      redirect_to tasks_page_url(@task.project), notice: "Returing from the create"
    else
      render new_tasks_path(@task.project), notice: "Cannnot enter data due to constraints"
    end
  end

  def edit  
  end

  def update
    if @task.update(tasks_create_params)
      redirect_to tasks_page_url(@task.project), :notice => "Updated Successfully"
    else
      redirect_to tasks_page_url(@task.project), :notice => "Cannot be updated"
    end
  end

  def destroy
    project = @task.project
    @task.destroy
    redirect_to tasks_page_url(project), :notice => "Deleted Successfully"
  end



  private 

  def tasks_create_params
    params.require(:task).
    permit(:company_id, :start_date, :expected_end_date, :description, :name, :project_id, :assignable_id, :assignable_type)
  end

  def set_task
    @task = current_employee.company.projects.find(params[:id]).tasks.find(params[:format])
    @task_type = params[:task_type]
  end

  def set_task_update
    @task = Task.find(params[:id])
  end

end
