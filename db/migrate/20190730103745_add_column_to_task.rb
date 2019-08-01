class AddColumnToTask < ActiveRecord::Migration
  def change
    add_reference :tasks, :reviewer, index: true
    add_foreign_key :tasks, :employees, column: :reviewer_id
  end
end
