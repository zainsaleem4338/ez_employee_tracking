class ProjectsController < ApplicationController
  load_and_authorize_resource :department, find_by: :sequence_num
  load_and_authorize_resource through: :department, find_by: :sequence_num

  # get /departments/:department_id/projects
  def index
    if params[:show_employees_only].present? && current_employee.role != Employee::ADMIN_ROLE
      @projects = @projects.employee_projects(current_employee)
    end
    @projects = @projects.paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # post /departments/:department_id/projects
  def create
    @project.status = Project::NEW_STATUS
    if @project.save
      flash[:success] = t('.success_notice', project_name: @project.name.downcase.titleize)
      redirect_to department_projects_path
    else
      flash[:danger] = t('.error_notice')
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
