class AddCompanyrefToTaskTimeLogs < ActiveRecord::Migration
  def change
    add_reference :task_time_logs, :company, index: true
    add_foreign_key :task_time_logs, :companies
  end
end
