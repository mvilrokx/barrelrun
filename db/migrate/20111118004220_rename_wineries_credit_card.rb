class RenameWineriesCreditCard < ActiveRecord::Migration
  def self.up
	rename_column :wineries, :credit_cards, :credit_cards_accepted
  end

  def self.down
  end
end

