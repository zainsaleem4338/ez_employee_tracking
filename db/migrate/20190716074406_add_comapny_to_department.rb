class AddComapnyToDepartment < ActiveRecord::Migration
  def change
    add_reference :departments, :company, index: true
    add_foreign_key :departments, :companies
  end
end
