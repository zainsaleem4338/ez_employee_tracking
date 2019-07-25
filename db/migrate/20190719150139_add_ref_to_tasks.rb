class AddRefToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :company, index: true
    add_foreign_key :tasks, :companies
    add_reference :tasks, :project, index: true
    add_foreign_key :tasks, :projects
  end
end
