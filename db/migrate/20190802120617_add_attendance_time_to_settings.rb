class AddAttendanceTimeToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :attendance_time, :time
  end
end
