class AddAllocatedLeavesToSettings < ActiveRecord::Migration
  def change
  	add_column :settings, :allocated_leaves, :integer
  end
end
