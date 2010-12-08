class AddAverageRatingToWinery < ActiveRecord::Migration
  def self.up
    add_column :wineries, :average_rating, :integer
  end

  def self.down
    remove_column :wineries, :average_rating
  end
end
