class ProjectsController < ApplicationController
  before_action :set_department, only: [:edit, :index, :new, :create]
  load_and_authorize_resource through_association: :company

  def create
    @project.status = Project::NEW_STATUS
    if @project.save
      redirect_to projects_path, notice: t('.success_notice')
    else
      render new_project_path, notice: @project.errors
    end
  end

  def destroy
    @project.destroy
    if @project.destroyed?
      redirect_to projects_path, notice: t('.success_notice')
    else
      redirect_to projects_path, notice: t('.error_notice')
    end
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: t('.success_notice')
    else
      redirect_to projects_path, notice: t('.error_notice')
    end
  end

  private

  def project_params
    params.require(:project).permit(:description, :name, :start_date, :expected_end_date, :department_id)
  end

  def set_department
    @departments = current_employee.company.departments
  end
end
