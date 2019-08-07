class DepartmentsController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:show_employees_only].present? && current_employee.role != Employee::ADMIN_ROLE
      @departments = @departments.employee_departments(current_employee)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    respond_to do |format|
      if @department.save
        format.html do
          flash[:success] = t('.success_notice')
          redirect_to departments_path
        end
        format.json { render :show, status: :created, location: @department }
      else
        format.html { render :new }
        format.json do
          render json: @department.errors,
          status: :unprocessable_entity
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html do
          flash[:success] = t('.success_notice')
          redirect_to @department
        end
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json do
          render json: @department.errors,
          status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @department.destroy
    respond_to do |format|
      if @department.destroyed?
        format.html do
          flash[:success] = t('.success_notice')
          redirect_to departments_path
        end
        format.json { head :no_content }
      else
        format.html do
          flash[:danger] = t('.error_notice')
          redirect_to departments_path
        end
      end
    end
  end

  private
  def department_params
    params.require(:department).permit(:name, :description)
  end
end