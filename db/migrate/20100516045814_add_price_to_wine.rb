class AddPriceToWine < ActiveRecord::Migration
  def self.up
    add_column :wines, :price, :decimal, :precision => 8, :scale => 2, :default => 0
  end

  def self.down
    remove_column :wines, :price
  end
end
