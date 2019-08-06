class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.integer :company_id
      t.datetime :event_date, null: false
    end
  end
end
