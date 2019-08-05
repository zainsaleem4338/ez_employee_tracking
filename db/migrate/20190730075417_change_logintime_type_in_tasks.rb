class ChangeLogintimeTypeInTasks < ActiveRecord::Migration
  def change
    change_column :tasks, :log_time, :integer
  end
end
