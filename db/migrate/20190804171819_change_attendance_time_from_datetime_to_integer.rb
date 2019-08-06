class ChangeAttendanceTimeFromDatetimeToInteger < ActiveRecord::Migration
  def change
  	change_column :settings, :attendance_time, :integer
  end
end
