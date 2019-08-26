class DepartmentsController < ApplicationController
  load_and_authorize_resource :department, through_association: :company

  def show
    @teams = @department.teams
    @projects = @department.projects
    if current_employee.role != Employee::ADMIN_ROLE
      @teams = @teams.show_teams_employee(current_employee)
      @projects = @projects.get_projects(current_employee)
    end
  end


  # get /departments
  def index
    if params[:show_employees_only].present? && current_employee.role != Employee::ADMIN_ROLE
      @departments = @departments.employee_departments(current_employee)
    end
    @departments = @departments.paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
    end
  end

  # get /departments/:id/edit
  def edit
    respond_to do |format|
      format.js { render file: '/departments/modal.js.erb' }
    end
  end

  # get /departments/new
  def new
    respond_to do |format|
      format.js { render file: '/departments/modal.js.erb' }
    end
  end

  # post /departments
  def create
    respond_to do |format|
      if @department.save
        flash[:success] = t('.success_notice')
        format.js do
          render js: "location.href = '#{departments_path}'"
        end
      else
        format.js { render file: '/departments/modal.js.erb' }
      end
    end
  end

  # patch /departments/:id
  def update
    respond_to do |format|
      if @department.update(department_params)
        flash[:success] = t('.success_notice')
        format.js do
          render js: "location.href = '#{request.referrer}'"
        end
      else
        format.js { render file: '/departments/modal.js.erb' }
      end
    end
  end

  # delete /departments/:id
  def destroy
    @department.destroy
    respond_to do |format|
      if @department.destroyed?
        flash[:success] = t('.success_notice')
        format.js do
          render js: "location.href = '#{departments_path}'"
        end
      else
        flash[:danger] = t('.error_notice')
        format.js do
          render js: "location.href = '#{request.referrer}'"
        end
      end
    end
  end

  private
  def department_params
    params.require(:department).permit(:name, :description)
  end
end
