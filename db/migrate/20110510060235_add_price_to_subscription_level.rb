class AddPriceToSubscriptionLevel < ActiveRecord::Migration
  def self.up
    add_column :registration_levels, :price, :decimal,  :precision => 8, :scale => 2
  end

  def self.down
    remove_column :registration_levels, :price
  end
end
