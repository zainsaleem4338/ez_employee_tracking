class AddRefToAttendance < ActiveRecord::Migration
  def change
    add_reference :attendances, :employee, index: true
    add_foreign_key :attendances, :employees
    add_reference :attendances, :company, index: true
    add_foreign_key :attendances, :companies
  end
end
