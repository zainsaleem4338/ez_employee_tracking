class AddDepartmentToUser < ActiveRecord::Migration
  def change
    add_reference :users, :department, index: true
    add_foreign_key :users, :departments
  end
end
