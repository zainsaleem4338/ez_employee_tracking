class RemoveIndexOnEmployees < ActiveRecord::Migration
  def change
    remove_index "employees", name: "index_employees_on_email"
  end
end
