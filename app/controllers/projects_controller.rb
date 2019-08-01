class ProjectsController < ApplicationController
  before_action :set_department, only: [:edit, :index, :new, :create]
  load_and_authorize_resource through_association: :company
 
  def create
    @project.status = Project::NEW_STATUS
    if @project.save
      flash[:success] = 'Project Created Successfully!'
      redirect_to projects_path
    else
      flash[:danger] = 'Could not create Project!'
      render new_project_path
    end
  end

  def destroy
    @project.destroy
    if @project.destroyed?
      flash[:success] = 'Project Deleted Successfully!'
    else
      flash[:danger] = 'Could not delete Project!'
    end
    redirect_to projects_path
  end

  def update
    if @project.update(project_params)
      flash[:success] = 'Project Updated Successfully!'
    else
      flash[:danger] = 'Could not update Project!'
    end
    redirect_to projects_path
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
