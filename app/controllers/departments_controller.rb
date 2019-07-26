class DepartmentsController < ApplicationController
  load_and_authorize_resource through_association: :company

  before_action :set_department, only: [:show, :edit, :update, :destroy]
  def index
    @departments = current_employee.company.departments.all
  end

  def show
  end

  def new
    @department = Department.new
  end

  def edit
  end

  def create
    @department = current_employee.company.departments.new(department_params)
    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: 'Department was successfully created.' }
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
    def set_department
      @department = current_employee.company.departments.find(params[:id])
    end
    def department_params
      params.require(:department).permit(:name, :description)
    end
end
