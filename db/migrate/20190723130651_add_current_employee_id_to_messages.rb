class AddCurrentEmployeeIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :employee_id, :integer
  end
end
