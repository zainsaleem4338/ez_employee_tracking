require 'attendance'
# Used in idex.html.erb
# Helper for the employee views
module EmployeesHelper
  def present_marked?
    @attendance = Attendance.find_by(employee_id: @employee.id)
    !@attendance.nil?
  end

  def admin?
    session[:is_admin]
  end
end
