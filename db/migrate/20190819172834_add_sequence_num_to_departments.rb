class AddSequenceNumToDepartments < ActiveRecord::Migration
  
  
  def self.up
    add_column :departments, :sequence_num, :integer,:null=>false
    update_sequence_num_values
    add_index :departments, [:sequence_num,:company_id], :unique=>true
  end

  def self.down
    remove_index :departments,:column=>[:sequence_num,:company_id]
    remove_column :departments, :sequence_num
  end

  def self.update_sequence_num_values
    Company.all.each do |parent|
      cntr=1
      parent.departments.order("created_at").all.each do |nested|
        nested.sequence_num =cntr
        cntr+=1
        nested.save
      end
    end
  end
end

