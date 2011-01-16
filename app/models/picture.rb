class Picture < ActiveRecord::Base
	belongs_to :pictureable, :polymorphic => true
   
#   belongs_to :event

	has_attached_file :photo,
                    :styles => {:micro  => "50x50>",
                                :thumb  => "100x100>",
                                :small  => "200x200>",
                                :medium => "300x300>",
                                :large  => "600x600>",
                                :xlarge => "1200x1200>"
                               },
                    :url => "/assets/pictures/:class/:id/:style/:basename.:extension",  
                    :path => ":rails_root/public/assets/pictures/:class/:id/:style/:basename.:extension"  

  #Controls the number of pictures you see per page (pagination)
  cattr_reader :per_page
  @@per_page = 10

#   validates_attachment_size :photo, :less_than => 5.megabytes  
#   validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']     
  validates_attachment_presence :photo
  
	def url(*args)
		photo.url(*args)
	end
  
	def name
		photo_file_name
	end
  
	def content_type
		photo_content_type
	end
  
	def file_size
		photo_file_size
	end
  
end
