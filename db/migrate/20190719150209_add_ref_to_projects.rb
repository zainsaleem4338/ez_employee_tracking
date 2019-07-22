class AddRefToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :company, index: true
    add_foreign_key :projects, :companies
    add_reference :projects, :department, index: true
    add_foreign_key :projects, :departments
  end
end
