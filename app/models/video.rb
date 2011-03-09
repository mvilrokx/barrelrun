class Video < ActiveRecord::Base
	belongs_to :videoable, :polymorphic => true
   
  before_save :only_one_welcome_video_per_winery
  
#   belongs_to :event

	has_attached_file :movie,
                  	:styles => {:micro  => ["50x50>", :jpg],
                                :thumb  => ["100x100>", :jpg],
                                :small  => ["200x200>", :jpg],
                                :medium => ["300x300>", :jpg],
                                :large  => ["600x600>", :jpg],
                                :xlarge => ["1200x1200>", :jpg]
                               },
                    :url => "/assets/videos/:class/:id/:style/:basename.:content_type_extension",  
                    :path => ":rails_root/public/assets/videos/:class/:id/:style/:basename.:content_type_extension",
                    :processors => [ :video_thumbnail ]

  #Controls the number of movies you see per page (pagination)
  cattr_reader :per_page
  @@per_page = 10

#   validates_attachment_size :photo, :less_than => 5.megabytes  
#   validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
#  validates_attachment_presence :movie

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
	
  def video?
    [ 'application/x-mp4',
      'video/mpeg',
      'video/quicktime',
      'video/x-la-asf',
      'video/x-ms-asf',
      'video/x-msvideo',
      'video/x-sgi-movie',
      'video/x-flv',
      'flv-application/octet-stream',
      'video/3gpp',
      'video/3gpp2',
      'video/3gpp-tt',
      'video/BMPEG',
      'video/BT656',
      'video/CelB',
      'video/DV',
      'video/H261',
      'video/H263',
      'video/H263-1998',
      'video/H263-2000',
      'video/H264',
      'video/JPEG',
      'video/MJ2',
      'video/MP1S',
      'video/MP2P',
      'video/MP2T',
      'video/mp4',
      'video/MP4V-ES',
      'video/MPV',
      'video/mpeg4',
      'video/mpeg4-generic',
      'video/nv',
      'video/parityfec',
      'video/pointer',
      'video/raw',
      'video/rtx' ].include?(movie.content_type)
  end
  
  protected
	  def only_one_welcome_video_per_winery
      if self.welcome?
        current_welcome_video = Video.first(:conditions => {:videoable_id => self.videoable_id, :videoable_type => 'Winery', :welcome => true})
        if current_welcome_video then 
          current_welcome_video.welcome = false
          current_welcome_video.save
        end
      end
    end
   	
end
