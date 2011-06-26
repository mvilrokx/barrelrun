class AddTermsOfServiceToUserAndWinery < ActiveRecord::Migration
  def self.up
    add_column :wineries, :accepts_terms_of_service, :boolean
    add_column :users, :accepts_terms_of_service, :boolean
  end

  def self.down
    remove_column :wineries, :accepts_terms_of_service
    remove_column :users, :accepts_terms_of_service
  end
end
