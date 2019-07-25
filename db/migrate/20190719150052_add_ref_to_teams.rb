class AddRefToTeams < ActiveRecord::Migration
  def change
    add_reference :teams, :company, index: true
    add_foreign_key :teams, :companies
  end
end
