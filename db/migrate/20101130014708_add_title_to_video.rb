class AddTitleToVideo < ActiveRecord::Migration
  def self.up
    add_column :videos, :title, :string
    add_column :videos, :primary, :boolean
  end

  def self.down
    remove_column :videos, :title
    remove_column :videos, :primary
  end
end
