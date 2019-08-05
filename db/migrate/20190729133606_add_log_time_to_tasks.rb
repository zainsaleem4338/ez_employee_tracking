class AddLogTimeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :log_time, :time
  end
end
