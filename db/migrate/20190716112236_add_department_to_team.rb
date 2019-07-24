class AddDepartmentToTeam < ActiveRecord::Migration
  def change
    add_reference :teams, :department, index: true
    add_foreign_key :teams, :departments
  end
end
