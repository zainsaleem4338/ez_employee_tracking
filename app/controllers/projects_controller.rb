class ProjectsController < ApplicationController
  before_action :set_project, only: [:edit, :show, :update, :destroy]
  before_action :set_department, only: [:edit, :index, :new, :create]

  def index
    current_employee = Employee.find(1)
    if current_employee.role == "admin"
      @projects = current_employee.company.projects
    end
  end

  def new
    current_employee = Employee.find(1)
    @project = current_employee.company.projects.new
  end

  def create
    current_employee = Employee.find(1)
    @project = current_employee.company.projects.create(projects_params)
    @project.status = "new"
    if @project.save
      redirect_to projects_path, notice: "Returing from the create"
    else
      render new_project_path, notice: "Cannnot enter data due to constraints"
    end
    
  end

  def edit
  end

  def destroy
    @project.destroy
    redirect_to projects_path, :notice => "Deleted Successfully"
  end

  def update
    if @project.update(projects_params)
      redirect_to projects_path, :notice => "Updated Successfully"
    else
      redirect_to projects_path, :notice => "Cannot be updated"
    end
  end

  private

  def projects_params
    params.require(:project).
    permit(:description, :name, :start_date, :end_date, :department_id)
  end

  def set_department
    current_employee = Employee.find(1)
    @departments = current_employee.company.departments
  end

  def set_project
    current_employee = Employee.find(1)
    @project = current_employee.company.projects.find(params[:id])
  end
end
