class AddWineriesAcceptCredit < ActiveRecord::Migration
  def self.up
    add_column :wineries, :accept_credit, :boolean
  end

  def self.down
	remove_column :wineries, :accept_credit
  end
end
