class SessionsController < Devise::SessionsController
  def new
    super
  end
  def create
    if(current_company.blank?)
      flash[:danger] = 'Invalid Company!'
      return redirect_to new_employee_session_path
    end
    employee = Employee.find_by(email: params[:employee][:email], company_id: current_company.id)
    if employee.present?
      if !employee.active
        flash[:danger] = 'Can not log in, Employee is inactive!'
      elsif employee.confirmation_token.present?
        flash[:danger] = 'Please confirm your email!'
        return redirect_to new_employee_session_path
      elsif !employee.valid_password?(params[:employee][:password])
        flash[:danger] = 'Invalid password or email!'
        return redirect_to new_employee_session_path
      end
    else
      flash[:danger] = 'Invalid password or email!'
      return redirect_to new_employee_session_path
    end
    if current_company.subdomain == employee.company.subdomain
      clean_up_passwords(employee)
      sign_in(resource_name, employee)
      yield employee if block_given?
      if flash[:alert].blank?
        flash[:success] = 'Employee signed in successfully!'
      end
      respond_with employee, location: menus_index_path 
    else
      flash[:danger] = 'Employee does not belong to #{current_company.name}!'
      redirect_to new_employee_session_path
    end
  end
end
