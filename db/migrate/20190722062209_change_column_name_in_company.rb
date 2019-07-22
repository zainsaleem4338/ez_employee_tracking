class ChangeColumnNameInCompany < ActiveRecord::Migration
  def change
    rename_column :companies, :user_id, :employee_id
  end
end
