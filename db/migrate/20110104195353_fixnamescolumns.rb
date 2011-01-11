class Fixnamescolumns < ActiveRecord::Migration
  def self.up
    rename_column :users, :firstname, :first_name
    rename_column :users, :lastname, :last_name
    rename_column :wineries, :contact_firstname, :contact_first_name
    rename_column :wineries, :contact_lastname, :contact_last_name
  end

  def self.down
    rename_column :users, :first_name, :firstname
    rename_column :users, :last_name, :lastname
    rename_column :wineries, :contact_first_name, :contact_firstname
    rename_column :wineries, :contact_last_name, :contact_lastname
  end
end
