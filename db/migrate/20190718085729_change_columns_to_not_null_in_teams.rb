class ChangeColumnsToNotNullInTeams < ActiveRecord::Migration
  def change
    change_column :teams, :name, :string, null: false
    change_column :teams, :department_id, :integer, null: false
  end
end
