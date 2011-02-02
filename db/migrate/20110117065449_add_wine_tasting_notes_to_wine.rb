class AddWineTastingNotesToWine < ActiveRecord::Migration
  def self.up
    add_column :wines, :tasting_notes_file_name,    :string
    add_column :wines, :tasting_notes_content_type, :string
    add_column :wines, :tasting_notes_file_size,    :integer
    add_column :wines, :tasting_notes_updated_at,   :datetime
  end

  def self.down
    remove_column :wines, :tasting_notes_file_name
    remove_column :wines, :tasting_notes_content_type
    remove_column :wines, :tasting_notes_file_size
    remove_column :wines, :tasting_notes_updated_at
  end
end
