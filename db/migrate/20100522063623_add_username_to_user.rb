class AddUsernameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :birthdate, :date
    add_column :users, :telephone, :string
    add_column :users, :address, :string
    add_column :users, :address2, :string
    add_column :users, :address3, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zipcode, :string
  end

  def self.down
    remove_column :users, :username
    remove_column :users, :firstname
    remove_column :users, :lastname
    remove_column :users, :birthdate
    remove_column :users, :telephone
    remove_column :users, :address
    remove_column :users, :address2
    remove_column :users, :address3
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :zipcode
  end
end
