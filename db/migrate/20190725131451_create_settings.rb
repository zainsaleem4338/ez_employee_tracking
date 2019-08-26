class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.text :working_days
    end
  end
end
