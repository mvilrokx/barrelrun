class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.integer :videoable_id
      t.string :videoable_type
      t.string :movie_file_name
      t.string :movie_content_type
      t.integer :movie_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
