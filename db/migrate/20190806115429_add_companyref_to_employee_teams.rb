class AddCompanyrefToEmployeeTeams < ActiveRecord::Migration
  def change
    add_reference :employee_teams, :company, index: true
    add_foreign_key :employee_teams, :companies
  end
end
