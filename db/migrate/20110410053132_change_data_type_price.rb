class ChangeDataTypePrice < ActiveRecord::Migration
  def self.up
    change_table :wines do |t|
      t.change :price, :float
    end
  end

  def self.down
    change_table :wines do |t|
      t.change :price, :decimal,  :precision => 8, :scale => 2
    end
  end
end
