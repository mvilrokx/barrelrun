class RenamePrimaryToWelcome < ActiveRecord::Migration
  def self.up
    rename_column :videos, :primary, :welcome
  end

  def self.down
    rename_column :videos, :welcome, :primary
  end
end
