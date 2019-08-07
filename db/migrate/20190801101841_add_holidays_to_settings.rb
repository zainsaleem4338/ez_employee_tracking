class AddHolidaysToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :holidays, :text
  end
end
