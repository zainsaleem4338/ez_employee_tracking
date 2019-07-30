class AddColumnToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :reviewer, :integer
    add_foreign_key :tasks, :employees, column: :reviewer_id
  end
end
