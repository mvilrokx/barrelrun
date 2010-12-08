class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.integer :pictureable_id
      t.string :pictureable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
