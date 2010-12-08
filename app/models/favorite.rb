class Favorite < ActiveRecord::Base

	belongs_to :favorable, :polymorphic => true
  belongs_to :user
  
  validates_uniqueness_of :favorable_id, :scope => [:user_id, :favorable_type], :message => 'You already have this marked as a favorite.'

end
