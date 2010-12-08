class Video < ActiveRecord::Base
	belongs_to :videoable, :polymorphic => true
   
  before_save :only_one_primary_video_per_winery
  
#   belongs_to :event

	has_attached_file :movie,
                    :url => "/assets/videos/:class/:id/:style/:basename.:extension",  
                    :path => ":rails_root/public/assets/videos/:class/:id/:style/:basename.:extension"  

  #Controls the number of pictures you see per page (pagination)
  cattr_reader :per_page
  @@per_page = 10

#   validates_attachment_size :photo, :less_than => 5.megabytes  
#   validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']     
	def url(*args)
		movie.url(*args)
	end
  
	def name
		movie_file_name
	end
  
	def content_type
		movie_content_type
	end
  
	def file_size
		movie_file_size
	end
	
	protected
	  def only_one_primary_video_per_winery
      if self.primary?
        current_primary_video = Video.first(:conditions => {:videoable_id => self.videoable_id, :videoable_type => 'Winery', :primary => true})
        current_primary_video.primary = false
        current_primary_video.save
      end
    end
   	
end
