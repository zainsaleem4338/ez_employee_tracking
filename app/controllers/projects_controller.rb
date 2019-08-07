class ProjectsController < ApplicationController
  load_and_authorize_resource :department
  load_and_authorize_resource through: :department

  # get /departments/:department_id/projects
  def index
    if params[:show_employees_only].present? && current_employee.role != Employee::ADMIN_ROLE
      @projects = @projects.employee_projects(current_employee)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  # post /departments/:department_id/projects
  def create
    @project.status = Project::NEW_STATUS
    if @project.save
      flash[:success] = t('.success_notice')
      redirect_to department_projects_path
    else
      flash[:danger] = @project.errors
      redirect_to new_department_project_path
    end
  end

  # delete /departments/:department_id/projects/:id
  def destroy
    @project.destroy
    if @project.destroyed?
      flash[:success] = t('.success_notice')
    else
      flash[:danger] = t('.error_notice')
    end
    redirect_to department_projects_path
  end

  # patch /departments/:department_id/projects/:id
  def update
    if @project.update(project_params)
      flash[:success] = t('.success_notice')
    else
      flash[:danger] = t('.error_notice')
    end
    redirect_to department_projects_path
  end

  private

  def project_params
    params.require(:project).permit(:description, :name, :start_date, :expected_end_date, :department_id)
  end
end
