class RemoveRoleIndexToEmployees < ActiveRecord::Migration
  def change
    remove_index "employees", name: "index_employees_on_email_and_role"
  end
end
