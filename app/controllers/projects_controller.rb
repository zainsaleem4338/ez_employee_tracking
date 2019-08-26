class ProjectsController < ApplicationController
  load_and_authorize_resource :department
  load_and_authorize_resource through: :department

  # get /departments/:department_id/projects
  def index
    if params[:show_employees_only].present? && current_employee.role != Employee::ADMIN_ROLE
      @projects = @projects.employee_projects(current_employee)
    end
    @projects = @projects.paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
    end
  end

  # post /departments/:department_id/projects
  def create
    @project.status = Project::NEW_STATUS
    respond_to do |format|
      if @project.save
        format.html do
          flash[:success] = t('.success_notice', project_name: @project.name.downcase.titleize)
          redirect_to department_projects_path
        end
      else
        format.html do
          flash[:danger] = t('.error_notice')
          redirect_to department_projects_path
        end
      end
    end
  end
  # delete /departments/:department_id/projects/:id
  def destroy
    @project.destroy
    respond_to do |format|
      if @project.destroyed?
        format.html do
          flash[:success] = t('.success_notice')
          redirect_to department_projects_path
        end
      else
        format.html do
          flash[:danger] = t('.error_notice')
          redirect_to department_projects_path
        end
      end
    end
  end

  # patch /departments/:department_id/projects/:id
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html do
          flash[:success] = t('.success_notice')
          redirect_to department_projects_path
        end
      else
        format.html do
          flash[:danger] = t('.error_notice')
          redirect_to department_projects_path
        end
      end
    end
  end

  private

  def project_params
    params.require(:project).permit(:description, :name, :start_date, :expected_end_date, :department_id)
  end
end
