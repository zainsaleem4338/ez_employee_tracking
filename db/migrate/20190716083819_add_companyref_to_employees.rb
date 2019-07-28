class AddCompanyrefToEmployees < ActiveRecord::Migration
  def change
    add_reference :employees, :company, index: true
    add_foreign_key :employees, :companies
  end
end
