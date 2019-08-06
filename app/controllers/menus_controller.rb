class MenusController < ApplicationController
  skip_before_action :authenticate_employee!, only: [:home, :search_email]

  def index
  end

  def home   
  end
  
  def search_email
    @email = params[:email]
    if(@email.present?)
      employees = Employee.where(email: params[:email])
      @companies = []
      employees.each do |employee|
        company = Company.find_by(id: employee.company_id)
        @companies.push(company)
      end
    end
    respond_to do |format|
      format.js
    end
  end
end
