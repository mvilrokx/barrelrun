class AddAverageRatingToSpecial < ActiveRecord::Migration
  def self.up
    add_column :specials, :average_rating, :decimal,  :precision => 4, :scale => 2
  end

  def self.down
    remove_column :specials, :average_rating
  end
end
