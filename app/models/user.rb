class User < ActiveRecord::Base
   
  has_many :comments, :as => :commentable, :dependent => :delete_all
  has_many :favorites, :as => :favorable, :dependent => :delete_all

  validates_presence_of :username, :email, :firstname, :lastname, :lat, :lng 
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
                 :firstname, :lastname, :username, :birthdate,
                 :telephone, :address, :address2, :address3,
                 :city, :state, :zipcode, :country
  ajaxful_rater

  # Virtual attribute for GeoCoding
  def complete_address
    [address, city, state, zipcode, country].join(', ')
  end

  acts_as_mappable # :auto_geocode => {:field=>:complete_address} => this only works on creation, not on update so I added the code below to handle both update and create.

  before_validation :geocode_address

  private
  def geocode_address
   geo = Geokit::Geocoders::MultiGeocoder.geocode(complete_address)
   errors.add(:complete_address, "Could not Geocode address") if !geo.success
   self.lat, self.lng = geo.lat,geo.lng if geo.success
  end

end
