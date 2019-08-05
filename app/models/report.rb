class Report < ActiveRecord::Base

  def self.attendance_data(current_employee)
    end_date = "31-12-#{Date.today.year}".to_date
    week_days = [1, 2, 3, 4, 5]
    attendances_array = []
    current_employee.company.employees.each do |employee|
      @attendances = employee.attendances.where('status = ?', Attendance::STATUS[:PRESENT]).order(login_time: :asc).select { |attendance| attendance.login_time.year == Date.today.year && attendance.logout_time != nil }
      expected_working_days = (@attendances.first.login_time.to_date..@attendances.last.login_time.to_date).to_a.select { |k| week_days.include?(k.wday) }.count
      leaves = (end_date.month - @attendances.first.login_time.month + 1) * 2
      actual_working_days = @attendances.count
      half_days = @attendances.select { |attendance| ((attendance.logout_time - attendance.login_time) / 3600) <= 6 }.count
      full_days = actual_working_days - half_days
      absents = expected_working_days - actual_working_days
      attendances_array << {
        employee: employee,
        presents: full_days,
        half_days: half_days,
        absents: absents,
        leaves_remaining: leaves - absents - (half_days / 2).floor
      }
    end
    attendances_array
  end
end
