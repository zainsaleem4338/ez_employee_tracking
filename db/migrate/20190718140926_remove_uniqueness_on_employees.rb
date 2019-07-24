class RemoveUniquenessOnEmployees < ActiveRecord::Migration
  def change
    change_column :employees, :email, :string, unique: false
  end
end
