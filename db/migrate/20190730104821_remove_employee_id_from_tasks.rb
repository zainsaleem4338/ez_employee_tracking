class RemoveEmployeeIdFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :employee_id
  end
end
