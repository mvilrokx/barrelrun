class ChangeDataTypeForRate < ActiveRecord::Migration
  def self.up
    change_table :ratings do |t|
      t.change :rate, :decimal,  :precision => 4, :scale => 2
    end
  end

  def self.down
    change_table :ratings do |t|
      t.change :rate, :integer
    end
  end
end
