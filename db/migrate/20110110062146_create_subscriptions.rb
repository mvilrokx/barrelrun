class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :plan_id
      t.integer :winery_id
      t.string :status
      t.timestamps
    end
  end
  
  def self.down
    drop_table :subscriptions
  end
end
