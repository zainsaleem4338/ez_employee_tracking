class ProjectsController < ApplicationController
  before_action :set_department, only: [:edit, :index, :new, :create]
  load_and_authorize_resource through_association: :company
 
  def create
    @project.status = Project::NEW_STATUS
    if @project.save
      redirect_to projects_path, notice: "Returing from the create"
    else
      render new_project_path, notice: "Cannnot enter data due to constraints"
    end
  end

  def destroy
    @project.destroy
    if @project.destroyed?
      redirect_to projects_path, notice: "Deleted Successfully"
    else
      redirect_to projects_path, notice: "Cannot be Deleted Successfully"
    end
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: "Updated Successfully"
    else
      redirect_to projects_path, notice: "Cannot be updated"
    end
  end

  private

  def project_params
    params.require(:project).
    permit(:description, :name, :start_date, :expected_end_date, :department_id)
  end

  def set_department
    @departments = current_employee.company.departments
  end
end
