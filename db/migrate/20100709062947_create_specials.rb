class CreateSpecials < ActiveRecord::Migration
  def self.up
    create_table :specials do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.integer :winery_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :specials
  end
end
