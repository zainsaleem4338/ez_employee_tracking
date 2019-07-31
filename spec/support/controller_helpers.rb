module ControllerHelpers
  def sign_in(employee = double('employee'))
    if employee.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, { :scope => :employee })
      allow(controller).to receive(:current_employee).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(employee)
      allow(controller).to receive(:current_employee).and_return(employee)
    end
  end
end