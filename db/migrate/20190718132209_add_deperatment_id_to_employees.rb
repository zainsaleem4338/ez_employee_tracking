class AddDeperatmentIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :department_id, :integer
    add_column :employees, :active, :boolean, default: true
  end
end
