class RemoveWineriesCreditCard < ActiveRecord::Migration
  def self.up
	remove_column :wineries, :credit_cards_accepted
  end

  def self.down
    	add_column :wineries, :credit_cards_accepted, :string
  end
end
