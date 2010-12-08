class AddTitleToPicture < ActiveRecord::Migration
  def self.up
    add_column :pictures, :title, :string
  end

  def self.down
    remove_column :pictures, :title
  end
end
