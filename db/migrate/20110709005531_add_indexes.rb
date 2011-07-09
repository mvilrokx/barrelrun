class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :awards, :wine_id
    add_index :comments, :user_id
    add_index :favorites, :user_id
    add_index :ratings, :user_id
    add_index :comments, [:commentable_type, :commentable_id]
    add_index :credit_cards, [:creditable_type, :creditable_id]
    add_index :events, :winery_id
    add_index :specials, :winery_id
    add_index :subscriptions, :winery_id
    add_index :wines, :winery_id
    add_index :favorites, [:favorable_type, :favorable_id]
    add_index :pictures, [:pictureable_type, :pictureable_id]
    add_index :ratings, [:rateable_type, :rateable_id]
    add_index :videos, [:videoable_type, :videoable_id]
  end

  def self.down
    remove_index :awards, :wine_id
    remove_index :comments, :user_id
    remove_index :favorites, :user_id
    remove_index :ratings, :user_id
    remove_index :comments, [:commentable_type, :commentable_id]
    remove_index :credit_cards, [:creditable_type, :creditable_id]
    remove_index :events, :winery_id
    remove_index :specials, :winery_id
    remove_index :subscriptions, :winery_id
    remove_index :wines, :winery_id
    remove_index :favorites, [:favorable_type, :favorable_id]
    remove_index :pictures, [:pictureable_type, :pictureable_id]
    remove_index :ratings, [:rateable_type, :rateable_id]
    remove_index :videos, [:videoable_type, :videoable_id]
  end
end

