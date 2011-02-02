class User < ActiveRecord::Base
   
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  has_many :favorites
  has_many :favorite_wines, :through => :favorites, :source => :favorable, :source_type => 'Wine'
  has_many :favorite_wineries, :through => :favorites, :source => :favorable, :source_type => 'Winery'
  has_many :favorite_events, :through => :favorites, :source => :favorable, :source_type => 'Event'
  has_many :favorite_specials, :through => :favorites, :source => :favorable, :source_type => 'Special'
#  has_many :favorite_users, :through => :favorites, :source => :favorable, :source_type => 'User'
  
 	has_one :picture, :as => :pictureable, :dependent => :destroy
#  has_many :favorites, :as => :favorable, :dependent => :destroy
 	
  accepts_nested_attributes_for :picture

  validates_presence_of :username, :first_name, :last_name
  validates_length_of :username, :in => 6..19
  validates_uniqueness_of :telephone, :allow_nil => true, :allow_blank => true

  validates_each :birthdate do |model, attr, value|
    model.errors.add(attr, 'You must be at least 21 years old to be able to register.') if  value > Date.new((Date.today.year - 21),(Date.today.month),(Date.today.day))
  end   
   # Include default devise modules. Others available are:
   # :http_authenticatable, :token_authenticatable, :lockable, :confirmable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable, 
        :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
                 :first_name, :last_name, :username, :birthdate,
                 :telephone, :address, :address2, :address3,
                 :city, :state, :zipcode, :country, :picture_attributes
  # ajaxful_rater

  # Virtual attribute for GeoCoding
  def complete_address
    [address, city, state, zipcode, country].join(', ')
  end

  acts_as_mappable # :auto_geocode => {:field=>:complete_address} => this only works on creation, not on update so I added the code below to handle both update and create.

  before_validation :geocode_address

  Max_Attachments = 1
  Max_Attachment_Size = 5.megabyte

  private

    def geocode_address
     geo = Geokit::Geocoders::MultiGeocoder.geocode(complete_address)
     errors.add(:complete_address, "Could not Geocode address") if !geo.success
     self.lat, self.lng = geo.lat,geo.lng if geo.success
    end

  	def validate_attachments
     	errors.add_to_base("Too many attachments - maximum is #{Max_Attachments}") if pictures.length > Max_Attachments
    	pictures.each {|a| errors.add_to_base("#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB") if a.file_size > Max_Attachment_Size}
 	  end
end
