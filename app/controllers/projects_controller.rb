class ProjectsController < ApplicationController
  load_and_authorize_resource :department
  load_and_authorize_resource through: :department

  def index
    if !params[:checked].nil? && current_employee.role != 'Admin'
      @projects = Project.employee_projects(current_employee)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @project.status = Project::NEW_STATUS
    if @project.save
      redirect_to department_projects_path, notice: 'Returing from the create'
    else
      render new_department_project_path, notice: 'Cannnot enter data due to constraints'
    end
  end

  def destroy
    @project.destroy
    if @project.destroyed?
      redirect_to department_projects_path, notice: 'Deleted Successfully'
    else
      redirect_to department_projects_path, notice: 'Cannot be Deleted Successfully'
    end
  end

  def update
    if @project.update(project_params)
      redirect_to department_projects_path, notice: 'Updated Successfully'
    else
      redirect_to department_projects_path, notice: 'Cannot be updated'
    end
  end

  private

  def project_params
    params.require(:project)
          .permit(:description, :name, :start_date, :expected_end_date, :department_id)
  end
end
