class AddAttachmentsPictureToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :picture_file_name, :string
    add_column :events, :picture_content_type, :string
    add_column :events, :picture_file_size, :integer
    add_column :events, :picture_updated_at, :datetime
  end

  def self.down
    remove_column :events, :picture_file_name
    remove_column :events, :picture_content_type
    remove_column :events, :picture_file_size
    remove_column :events, :picture_updated_at
  end
end
