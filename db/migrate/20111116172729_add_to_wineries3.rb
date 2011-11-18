class AddToWineries3 < ActiveRecord::Migration
def self.up
    add_column :wineries, :descr, :text
    add_column :wineries, :hours, :string
  end

  def self.down
	remove_column :wineries, :descr
	remove_column :wineries, :hours
  end
end
