class SessionsController < Devise::SessionsController
  def new
    super
  end
  def create
    if(current_company.blank?)
      flash[:danger] = t('.invalid_company_notice')
      return redirect_to new_employee_session_path
    end
    employee = Employee.find_by(email: params[:employee][:email], company_id: current_company.id)
    if employee.blank? || !employee.valid_password?(params[:employee][:password])
      flash[:danger] = t('.invalid_pswd_email_notice')
      return redirect_to new_employee_session_path
    end
    if current_company.subdomain == employee.company.subdomain
      clean_up_passwords(employee)
      sign_in(resource_name, employee)
      yield employee if block_given?
      if flash[:alert].blank?
        flash[:notice] = t('.success_notice')
      end
      respond_with employee, location: menus_index_path
    else
      flash[:danger] = t('.not_belongs_to_company', current_company_name: current_company.name)
      redirect_to new_employee_session_path
    end
  end
end
