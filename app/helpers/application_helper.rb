require 'attendance'

module ApplicationHelper
  def present_marked?
    @company = Company.find(current_employee.company_id)
    @attendance = current_employee.todays_attendance_of_employee(@company)
    !@attendance.blank?
  end

  def logged_out?
    @company = Company.find(current_employee.company_id)
    @attendance = current_employee.todays_attendance_of_employee(@company)
    @attendance.logout_time
  end

  def admin?
    current_employee.role.eql? 'Admin'
  end
end
