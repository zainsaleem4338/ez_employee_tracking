class AddAttachmentTeamPicToTeams < ActiveRecord::Migration
  def self.up
    change_table :teams do |t|
      t.attachment :team_pic
    end
  end

  def self.down
    remove_attachment :teams, :team_pic
  end
end
