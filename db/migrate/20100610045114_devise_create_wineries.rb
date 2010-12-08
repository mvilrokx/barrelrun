class DeviseCreateWineries < ActiveRecord::Migration
  def self.up
    create_table(:wineries) do |t|
      t.database_authenticatable :null => false
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      # t.lockable

      t.timestamps
    end

    add_index :wineries, :email,                :unique => true
    add_index :wineries, :confirmation_token,   :unique => true
    add_index :wineries, :reset_password_token, :unique => true
    # add_index :wineries, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :wineries
  end
end
