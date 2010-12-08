class AddAverageRatingToWine < ActiveRecord::Migration
  def self.up
    add_column :wines, :average_rating, :integer
  end

  def self.down
    remove_column :wines, :average_rating
  end
end
