class RenameWineryIdToWineIdOnAward < ActiveRecord::Migration
  def self.up
    rename_column :awards, :winery_id, :wine_id
  end

  def self.down
    rename_column :awards, :wine_id, :winery_id
  end
end
