class Rating < ActiveRecord::Base

  belongs_to :rateable, :polymorphic => true
  belongs_to :user

  after_create   :update_average_rating
  after_save     :update_average_rating
  after_destroy  :update_average_rating

  def update_average_rating
#    logger.info("Entering update_average_rating")
    average_rating = Rating.average(:rate, :conditions => [ 'rateable_id = ? AND rateable_type = ?', rateable_id, rateable_type ] )
#    logger.info(average_rating)
    rateable = rateable_type.classify.constantize.find(rateable_id)
#    logger.info("2")
#    logger.info(rateable.winery_name)
#    logger.info(rateable.average_rating)
    rateable.average_rating = average_rating
#    logger.info(rateable.average_rating)
#    logger.info("3")
    rateable.update_attribute(:average_rating, average_rating)
#    rateable.save
#    logger.info("Leave")
  end

end
