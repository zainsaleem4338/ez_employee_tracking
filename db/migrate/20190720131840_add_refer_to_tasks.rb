class AddReferToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :assignable, polymorphic: true, index: true
  end
end
