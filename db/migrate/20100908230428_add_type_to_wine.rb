class AddTypeToWine < ActiveRecord::Migration
  def self.up
    add_column :wines, :color, :string
    add_column :wines, :varietal, :string
    add_column :wines, :vintage, :integer
  end

  def self.down
    remove_column :wines, :vintage
    remove_column :wines, :varietal
    remove_column :wines, :color
  end
end
