class AddIndexRoleToEmployees < ActiveRecord::Migration
  def change
    add_index :employees, [:email, :role], unique: true
  end
end
