class CreateAwards < ActiveRecord::Migration
  def self.up
    create_table :awards do |t|
      t.string :title
      t.text :description
      t.integer :winery_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :awards
  end
end
