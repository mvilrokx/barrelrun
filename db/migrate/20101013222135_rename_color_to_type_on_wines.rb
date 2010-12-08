class RenameColorToTypeOnWines < ActiveRecord::Migration
  def self.up
    rename_column :wines, :color, :wine_type
  end

  def self.down
    rename_column :wines, :wine_type, :color
  end
end
