class DepartmentsController < ApplicationController
  load_and_authorize_resource

  def create
    respond_to do |format|
      if @department.save
        format.html do
          flash[:success] = 'Department created Successfully!'
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
          flash[:success] = 'Department updated Successfully!'
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
          flash[:success] = 'Department deleted Successfully!'
          redirect_to departments_path
        end
        format.json { head :no_content }
      else
        format.html do
          flash[:danger] = 'Could not delete Department!'
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
