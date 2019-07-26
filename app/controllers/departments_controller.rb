class DepartmentsController < ApplicationController
  load_and_authorize_resource through_association: :company

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
