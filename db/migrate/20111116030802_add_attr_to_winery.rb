class AddAttrToWinery < ActiveRecord::Migration
   def self.up
    add_column :wineries, :descr, :string
    add_column :wineries, :price, :string
    add_column :wineries, :parking, :boolean
    add_column :wineries, :handicap, :boolean
    add_column :wineries, :credit_cards, :boolean
    add_column :wineries, :fam_friendly, :boolean
    add_column :wineries, :restaurant, :boolean
    add_column :wineries, :hours, :string
  end

  def self.down
	remove_column :wineries, :descr
	remove_column :wineries, :price
	remove_column :wineries, :parking
	remove_column :wineries, :handicap
	remove_column :wineries, :credit_cards
	remove_column :wineries, :fam_friendly
	remove_column :wineries, :restaurant
	remove_column :wineries, :hours
  end
end
