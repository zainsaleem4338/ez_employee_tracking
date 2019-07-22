class RemoveIndexOfCompanyIdToEmployees < ActiveRecord::Migration
  def change
    remove_index "employees", name: "index_employees_on_email_and_company_id"
  end
end
