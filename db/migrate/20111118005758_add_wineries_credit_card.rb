class AddWineriesCreditCard < ActiveRecord::Migration
  def self.up
	add_column :wineries, :credit_cards_accepted, :boolean
  end

  def self.down
	remove_column :wineries, :credit_cards_accepted
  end
end
