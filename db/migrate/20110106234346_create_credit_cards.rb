class CreateCreditCards < ActiveRecord::Migration
  def self.up
    create_table :credit_cards do |t|
      t.string :token
      t.date :expiration_date
      t.integer :creditable_id
      t.string :creditable_type
      t.timestamps
    end
  end
  
  def self.down
    drop_table :credit_cards
  end
end
