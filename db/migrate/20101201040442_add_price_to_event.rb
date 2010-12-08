class AddPriceToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :price, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :events, :contact_info_name, :string
    add_column :events, :contact_info_phone, :string
    add_column :events, :contact_info_email, :string
    add_column :events, :invitation_type, :string
  end

  def self.down
    remove_column :events, :invitation_type
    remove_column :events, :contact_info_email
    remove_column :events, :contact_info_phone
    remove_column :events, :contact_info_name
    remove_column :events, :price
  end
end
