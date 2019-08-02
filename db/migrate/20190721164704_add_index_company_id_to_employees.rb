class AddIndexCompanyIdToEmployees < ActiveRecord::Migration
  def change
    add_index :employees, [:email, :company_id], unique: true
  end
end
