class AddOwnershipStatusToWinery < ActiveRecord::Migration
  def self.up
    add_column :wineries, :ownership_status, :string
  end

  def self.down
    remove_column :wineries, :ownership_status
  end
end
