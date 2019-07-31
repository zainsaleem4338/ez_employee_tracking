module AttendanceHelper
  def logout_added?(attendance)
    attendance.logout_time.blank?
  end
end
