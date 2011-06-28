class ChangeDataTypeAvgRatingWinery < ActiveRecord::Migration
  def self.up
    change_table :wineries do |t|
      t.change :average_rating, :float
    end
  end

  def self.down
    change_table :wineries do |t|
      t.change :average_rating, :decimal,  :precision => 4, :scale => 2
    end
  end
end
