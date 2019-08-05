module AttendanceHelper

  def attendance_logout(attendance)
    return '-' if attendance.logout_time.blank?
    attendance.logout_time.to_formatted_s(:long_ordinal)
  end
end
