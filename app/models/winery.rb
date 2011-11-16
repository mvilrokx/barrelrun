class Winery < ActiveRecord::Base
  validates_uniqueness_of :username
  validates_presence_of :username, :winery_name, :contact_first_name,
                        :contact_last_name, :state, :telephone, :website_url

  validates_presence_of :city, :zipcode, :unless => :seed_data?

  validates_presence_of :accepts_terms_of_service, :if => :should_accept_terms?

  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :favorites, :as => :favorable, :dependent => :destroy
  has_many :wines, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :specials, :dependent => :destroy
  has_many :ratings, :as => :rateable, :dependent => :destroy
 	has_many :pictures, :as => :pictureable, :dependent => :destroy
 	has_many :videos, :as => :videoable, :dependent => :destroy
  has_many :credit_cards, :as => :creditable, :dependent => :destroy
#  accepts_nested_attributes_for :credit_cards
  has_one  :subscription, :dependent => :destroy
  accepts_nested_attributes_for :subscription

#  validates_associated :credit_cards

  has_many :awards, :through => :wines
  has_many :authentications, :dependent => :destroy

#  accepts_nested_attributes_for :pictures, :reject_if => lambda {|a| a[:photo].blank? }, :allow_destroy => true

  after_create   :store_customer_in_vault
  before_destroy :destroy_customer_in_vault

  def complete_address
    [address, city, state, zipcode, country].join(', ')
  end

  def with_cc_and_subscription
    self.credit_cards.build if credit_cards.empty?
    self.build_subscription
    self
  end

  def calc_average_rating
    Rating.average(:rate, :conditions => [ 'rateable_id = ? AND rateable_type = ?', self.id, 'Winery' ] )
  end

  # Include default devise modules. Others available are:
  # , :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :confirmable, :validatable,
         :http_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :username,
                  :winery_name, :owner_gm_name, :owner_gm_email,
                  :contact_first_name, :contact_last_name,
                  :telephone, :address, :address2, :address3,
                  :city, :state, :zipcode, :country, :website_url,
                  :credit_cards_attributes, :subscription_attributes,
                  :accepts_terms_of_service, :ownership_status, :descr, :price,
		  :parking, :handicap, :credit_cards, :fam_friendly, :restaurant
  attr_accessor :seed_data
#  validates_presence_of :lat, :lng
  acts_as_mappable :auto_geocode => {:field => :complete_address,
                                     :error_message => 'Could not locate address: you have to provide a valid address in order for us to be able to geographically locate you.'}

  named_scope :top_wineries, :order => "average_rating DESC",
                             :limit => 10,
                             :include => {:comments => :user}

  # ThinkingSphinx setup
  define_index do
    # Fields
    indexes winery_name
    indexes [:address, :address2, :address3, :city, :state, :zipcode, :country], :as => :address
    # Attributes
    has average_rating,  :facet => true, :type => :integer
    has "RADIANS(lat)",  :as => :latitude,  :type => :float
    has "RADIANS(lng)",  :as => :longitude, :type => :float
  end

  Max_Attachments = 10
  Max_Attachment_Size = 5.megabyte

  def name
    winery_name
  end

  def url
    if website_url =~ /^http/
      website_url
    else
      "http://" + website_url
    end
  end

 	protected

  	def validate_attachments
     	errors.add_to_base("Too many attachments - maximum is #{Max_Attachments}") if pictures.length > Max_Attachments
    	pictures.each {|a| errors.add_to_base("#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB") if a.file_size > Max_Attachment_Size}
 	  end

  	def store_customer_in_vault
      result = Braintree::Customer.create(
        :id => username
      )
      unless result.success?
        result.errors.each do |error|
          errors.add_to_base error.message
        end
      end
      credit_cards do |cc|
        result = Braintree::CreditCard.create(
          :customer_id => username,
          :number => cc.card_number, #"5105105105105100"
          :cvv => cc.card_verification_value,
          :expiration_month => cc.expiration_date.month,
          :expiration_year => cc.expiration_date.year,
          :options => {
              :verify_card => true
          }
        )
        if result.success?
          self.token = result.credit_card.token
        else
          result.errors.each do |error|
            ap error
            errors.add_to_base error.message
            self.creditable.errors.add_to_base error.message

          end
        end
      end
 	  end

  	def destroy_customer_in_vault
      result = Braintree::Customer.delete(username)
      unless result.success?
        result.errors.each do |error|
          errors.add_to_base error.message
        end
      end
 	  end

  	def should_accept_terms?
  	  ownership_status == 'CLAIMED'
 	  end

  	def seed_data?
  	  seed_data
 	  end
# Added to be able to RATE a winery (which is a devise user) but doesn't seem to work either'
#  protected
#    def password_required?
#      new_record? || destroyed?
#    end
end

