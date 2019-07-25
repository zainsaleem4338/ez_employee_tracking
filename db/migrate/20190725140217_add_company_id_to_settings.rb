class AddCompanyIdToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :company_id, :integer
  end
end
