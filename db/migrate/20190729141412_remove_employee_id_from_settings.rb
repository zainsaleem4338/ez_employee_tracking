class RemoveEmployeeIdFromSettings < ActiveRecord::Migration
  def change
    remove_column :settings, :employee_id
  end
end
