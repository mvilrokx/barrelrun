class AddWineryIdToWines < ActiveRecord::Migration
  def self.up
    add_column :wines, :winery_id, :integer
  end

  def self.down
    remove_column :wines, :winery_id
  end
end
