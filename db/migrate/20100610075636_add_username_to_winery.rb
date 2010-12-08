class AddUsernameToWinery < ActiveRecord::Migration
  def self.up
    add_column :wineries, :username, :string
    add_column :wineries, :winery_name, :string
    add_column :wineries, :owner_gm_name, :string
    add_column :wineries, :owner_gm_email, :string
    add_column :wineries, :contact_firstname, :string
    add_column :wineries, :contact_lastname, :string
    add_column :wineries, :telephone, :string
    add_column :wineries, :address, :string
    add_column :wineries, :address2, :string
    add_column :wineries, :address3, :string
    add_column :wineries, :city, :string
    add_column :wineries, :state, :string
    add_column :wineries, :zipcode, :string
    add_column :wineries, :country, :string
    add_column :wineries, :website_url, :string
    add_column :wineries, :rating_average, :decimal, :default => 0, :precision => 6, :scale => 2
    add_column :wineries, :lat, :float
    add_column :wineries, :lng, :float
  end

  def self.down
    remove_column :wineries, :username
    remove_column :wineries, :winery_name
    remove_column :wineries, :owner_gm_name
    remove_column :wineries, :owner_gm_email
    remove_column :wineries, :contact_firstname
    remove_column :wineries, :contact_lastname
    remove_column :wineries, :telephone
    remove_column :wineries, :address
    remove_column :wineries, :address2
    remove_column :wineries, :address3
    remove_column :wineries, :city
    remove_column :wineries, :state
    remove_column :wineries, :zipcode
    remove_column :wineries, :country
    remove_column :wineries, :website_url
    remove_column :wineries, :rating_average
    remove_column :wineries, :lat
    remove_column :wineries, :lng
  end
end
