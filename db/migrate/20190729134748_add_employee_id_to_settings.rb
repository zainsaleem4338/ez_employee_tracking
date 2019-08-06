class AddEmployeeIdToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :employee_id, :integer
  end
end
