class RemoveLogtimeFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :log_time
  end
end
