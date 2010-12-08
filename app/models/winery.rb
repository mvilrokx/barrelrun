class Winery < ActiveRecord::Base
  validates_presence_of :username, :email, :winery_name, :contact_firstname, 
                        :contact_lastname, :telephone, :website_url

  has_many :comments, :as => :commentable, :dependent => :delete_all
  has_many :favorites, :as => :favorable, :dependent => :delete_all
  has_many :wines, :dependent => :delete_all
  has_many :awards, :through => :wines
  has_many :events, :dependent => :delete_all
  has_many :specials, :dependent => :delete_all
  has_many :ratings, :as => :rateable, :dependent => :delete_all
 	has_many :pictures, :as => :pictureable, :dependent => :delete_all
 	has_many :videos, :as => :videoable, :dependent => :delete_all

#  accepts_nested_attributes_for :pictures, :reject_if => lambda {|a| a[:photo].blank? }, :allow_destroy => true

  def complete_address
    [address, city, state, zipcode, country].join(', ')
  end

  def calc_average_rating
    Rating.average(:rate, :conditions => [ 'rateable_id = ? AND rateable_type = ?', self.id, 'Winery' ] )
  end

  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable  
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :username,  
                 :winery_name, :owner_gm_name, :owner_gm_email,
                 :contact_firstname, :contact_lastname,
                 :telephone, :address, :address2, :address3,
                 :city, :state, :zipcode, :country, :website_url

#  ajaxful_rateable :stars => 5, :allow_update => true, :dimensions => [:overall]

  validates_presence_of :lat, :lng
  acts_as_mappable :auto_geocode => {:field=>:complete_address}

  named_scope :top_wineries, :order => "average_rating DESC", 
                             :limit => 10, 
                             :include => {:comments => :user}
                             
  # ThinkingSphinx setup
  define_index do
    indexes winery_name
    indexes wines.name, :as => :wine_name
    indexes wines.description, :as => :wine_description
    indexes [:address, :address2, :address3, :city, :state, :zipcode, :country], :as => :address

    has average_rating, :facet => true
    has lat, lng
  end

  Max_Attachments = 10
  Max_Attachment_Size = 5.megabyte

 	protected
  	def validate_attachments
     	errors.add_to_base("Too many attachments - maximum is #{Max_Attachments}") if pictures.length > Max_Attachments
    	pictures.each {|a| errors.add_to_base("#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB") if a.file_size > Max_Attachment_Size}
 	  end

# Added to be able to RATE a winery (which is a devise user) but doesn't seem to work either'
#  protected
#    def password_required?
#      new_record? || destroyed?
#    end
end
