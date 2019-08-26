class AddTimingsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :timings, :text
  end
end
