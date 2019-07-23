class CreateEmployeeTeams < ActiveRecord::Migration
  def change
    create_table :employee_teams do |t|
      t.integer :employee_id
      t.integer :team_id
      t.string :employee_type

      t.timestamps null: false
    end
  end
end
