class DepartmentsController < ApplicationController
  load_and_authorize_resource

  def create
    respond_to do |format|
      if @department.save
        format.html { redirect_to departments_path, notice: t('.success_notice')}
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
        format.html { redirect_to departments_path, notice: t('.success_notice') }
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
        format.html { redirect_to departments_path, notice: t('.success_notice')}
        format.json { head :no_content }
      else
        format.html { redirect_to departments_path, notice: t('.error_notice') }
      end
    end
  end

  private
  def department_params
    params.require(:department).permit(:name, :description)
  end
end
