class DropTableTenants < ActiveRecord::Migration
  def change
    drop_table :tenants
  end
end
