class EmployeesController < ApplicationController
  def index
  end
  def employees_lists
    @employees = Employee.order(:name)
    respond_to do |format|
      format.json { render json: @employees.where('name != ? AND name like ?', 'Admin', "%#{params[:q]}%") }
    end
  end
end
