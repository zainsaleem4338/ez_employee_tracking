class AddTaskAlertToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :task_alert, :integer
  end
end
