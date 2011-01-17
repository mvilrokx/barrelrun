class ChangeDataTypeForAverageRating < ActiveRecord::Migration
  def self.up
    change_table :wines do |t|
      t.change :average_rating, :decimal,  :precision => 4, :scale => 2
    end
    change_table :events do |t|
      t.change :average_rating, :decimal,  :precision => 4, :scale => 2
    end
    change_table :wineries do |t|
      t.change :average_rating, :decimal,  :precision => 4, :scale => 2
    end
  end

  def self.down
    change_table :wines do |t|
      t.change :average_rating, :integer
    end
    change_table :events do |t|
      t.change :average_rating, :integer
    end
    change_table :wineries do |t|
      t.change :average_rating, :integer
    end
  end
end
