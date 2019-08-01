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
        format.html { redirect_to departments_path, notice: 'Department was successfully created.' }
        format.json { render :show, status: :created, location: @department }
      else
        format.html { render :new }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: 'Department was successfully updated.' }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @department.destroy
    respond_to do |format|
      if @department.destroyed?
        format.html { redirect_to departments_path, notice: 'Department was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to departments_path, notice: 'Unable to delete team' }
      end
    end
  end

  private
  def department_params
    params.require(:department).permit(:name, :description)
  end
end
