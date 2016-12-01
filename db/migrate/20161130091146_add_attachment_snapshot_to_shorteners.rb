class AddAttachmentSnapshotToShorteners < ActiveRecord::Migration
  def self.up
    change_table :shorteners do |t|
      t.attachment :snapshot, :null => true 
    end
  end

  def self.down
    remove_attachment :shorteners, :snapshot
  end
end
