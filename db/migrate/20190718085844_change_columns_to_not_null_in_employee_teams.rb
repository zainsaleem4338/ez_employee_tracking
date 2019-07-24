class ChangeColumnsToNotNullInEmployeeTeams < ActiveRecord::Migration
  def change
    change_column :employee_teams, :employee_id, :integer, null: false
    change_column :employee_teams, :team_id, :integer, null: false
    change_column :employee_teams, :employee_type, :string, null: false
  end
end
