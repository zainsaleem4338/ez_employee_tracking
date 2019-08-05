class AddLeaveAndLateCountToEmployees < ActiveRecord::Migration
  def change
  	add_column :employees, :leaves, :integer
  	add_column :employees, :late_count, :integer
  end
end
