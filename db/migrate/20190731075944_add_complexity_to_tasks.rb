class AddComplexityToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :complexity, :integer
  end
end
