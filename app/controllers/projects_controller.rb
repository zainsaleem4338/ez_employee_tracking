class ProjectsController < ApplicationController
  load_and_authorize_resource :department
  load_and_authorize_resource through: :department

  def index
    if params[:show_employees_only].present? && current_employee.role != Employee::ADMIN_ROLE
      @projects = @projects.employee_projects(current_employee)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @project.status = Project::NEW_STATUS
    if @project.save
      flash[:success] = 'Project Created Successfully!'
      redirect_to department_projects_path
    else
      flash[:danger] = 'Could not create Project!'
      render new_department_project_path
    end
  end

  def destroy
    @project.destroy
    if @project.destroyed?
      flash[:success] = 'Project Deleted Successfully!'
    else
      flash[:danger] = 'Could not delete Project!'
    end
    redirect_to department_projects_path
  end

  def update
    if @project.update(project_params)
      flash[:success] = 'Project Updated Successfully!'
    else
      flash[:danger] = 'Could not update Project!'
    end
    redirect_to department_projects_path
  end

  private

  def project_params
    params.require(:project)
          .permit(:description, :name, :start_date, :expected_end_date, :department_id)
  end
end
