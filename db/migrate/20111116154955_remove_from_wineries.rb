class RemoveFromWineries < ActiveRecord::Migration
   def self.up
	remove_column :wineries, :descr
	remove_column :wineries, :hours
  end

  def self.down
    add_column :wineries, :descr, :string
    add_column :wineries, :hours, :string

  end
end
