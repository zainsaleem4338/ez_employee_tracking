class AddEmployeeRefToTaskTimeLogs < ActiveRecord::Migration
  def change
    add_reference :task_time_logs, :employee, index: true
    add_foreign_key :task_time_logs, :employees
    add_reference :task_time_logs, :task, index: true
    add_foreign_key :task_time_logs, :tasks
  end
end
