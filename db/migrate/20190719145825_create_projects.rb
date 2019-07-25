class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.string :status
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :expected_end_date

      t.timestamps null: false
    end
  end
end
