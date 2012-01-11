class User < ActiveRecord::Base
   
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  has_many :favorites
  has_many :favorite_wines, :through => :favorites, :source => :favorable, :source_type => 'Wine'
  has_many :favorite_wineries, :through => :favorites, :source => :favorable, :source_type => 'Winery'
  has_many :favorite_events, :through => :favorites, :source => :favorable, :source_type => 'Event'
  has_many :favorite_specials, :through => :favorites, :source => :favorable, :source_type => 'Special'
#  has_many :favorite_users, :through => :favorites, :source => :favorable, :source_type => 'User'
  
 	has_many :picture, :as => :pictureable, :dependent => :destroy
# I SHOULD BE USING has_one BUT THAT RAISES ERRORS IN THE UPDATE FORM SO USING HAS_MANY WHICH WORKS
# 	has_one :picture, :as => :pictureable, :dependent => :destroy
#  has_many :favorites, :as => :favorable, :dependent => :destroy
 	
  accepts_nested_attributes_for :picture, :reject_if => lambda {|a| a[:photo].blank? }, :allow_destroy => true

  validates_presence_of :username, :first_name, :last_name, :accepts_terms_of_service
  validates_length_of :username, :in => 6..19
  validates_uniqueness_of :telephone, :allow_nil => true, :allow_blank => true

  validates_each :birthdate do |model, attr, value|
    model.errors.add(attr, 'You must be at least 21 years old to be able to register.') if  value > Date.new((Date.today.year - 21),(Date.today.month),(Date.today.day))
  end   


  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
                 :first_name, :last_name, :username, :birthdate,
                 :telephone, :address, :address2, :address3,
                 :city, :state, :zipcode, :country, :picture_attributes,
                 :accepts_terms_of_service
  # ajaxful_rater

  # Virtual attribute for GeoCoding
  def complete_address
    [address, city, state, zipcode, country].compact.join(', ')
  end

  Max_Attachments = 1
  Max_Attachment_Size = 5.megabyte

  geocoded_by :complete_address, :latitude  => :lat, :longitude => :lng
  after_validation :geocode          # auto-fetch coordinates

  private

  	def validate_attachments
     	errors[:base] << "Too many attachments - maximum is #{Max_Attachments}" if picture.length > Max_Attachments
    	picture.each {|a| errors[:base] << "#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB" if a.file_size > Max_Attachment_Size}
 	  end
end
