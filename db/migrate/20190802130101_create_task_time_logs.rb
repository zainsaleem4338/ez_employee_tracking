class CreateTaskTimeLogs < ActiveRecord::Migration
  def change
    create_table :task_time_logs do |t|
      t.integer :hours

      t.timestamps null: false
    end
  end
end
