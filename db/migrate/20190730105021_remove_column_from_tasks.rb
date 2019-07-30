class RemoveColumnFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :reviewer_id_id
  end
end
