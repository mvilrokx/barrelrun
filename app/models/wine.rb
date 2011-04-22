class Wine < ActiveRecord::Base
 	has_many :comments, :as => :commentable, :dependent => :destroy, :order => "created_at DESC"
 	has_many :favorites, :as => :favorable, :dependent => :destroy
#    accepts_nested_attributes_for :favorites, :allow_destroy => true
 	has_many :pictures, :as => :pictureable, :dependent => :destroy
  has_many :ratings, :as => :rateable, :dependent => :destroy
  has_many :awards, :dependent => :destroy
 	belongs_to :winery

  accepts_nested_attributes_for :pictures, :reject_if => lambda {|a| a[:photo].blank? }, :allow_destroy => true
 
  validates_presence_of :name, :wine_type, :vintage, :varietal
 	validates_numericality_of :price, :vintage, :allow_blank => true
 	validate :price_must_be_at_least_a_cent, :validate_attachments
 	validates_associated :favorites

  before_validation :clear_tasting_notes

  cattr_reader :per_page
  @@per_page = 10

  cattr_reader :top_list_size
  @@top_list_size = 10

  Max_Attachments = 5
  Max_Attachment_Size = 5.megabyte

  named_scope :top_wines, lambda { |*top|
#      { :limit => top.first||=:top_list_size, :order => "average_rating DESC" }
    if top.empty? || top.first.nil?
      { :limit => 10, :order => "average_rating DESC" }
    else
      { :limit => top[0], :order => "average_rating DESC" }
    end
  } 

#  named_scope :top_wines, :order => "average_rating DESC", 
#                          :limit => 10,
#                          :include => {:comments => :user}
   
  named_scope :distinct_wine_types, :select => "distinct wine_type",
                                   :order => "wine_type"
  named_scope :distinct_varietals, :select => "distinct varietal",
                                   :order => "varietal"

  named_scope :highest_price, :select => "max(price)"

  # ThinkingSphinx setup
  define_index do
    # Fields
    indexes :name
    indexes description
    indexes varietal, :facet => true # this implicitly gives an attribute called varietal_facet
    indexes wine_type, :facet => true # this implicitly gives an attribute called wine_type_facet
    # Joins
    join winery
    # Attributes
    has vintage, :facet => true
    has price, :facet => trueta
    has average_rating, :facet => true, :type => :integer
    has "RADIANS(wineries.lat)",  :as => :latitude,  :type => :float
    has "RADIANS(wineries.lng)", :as => :longitude, :type => :float
  end
  
  has_attached_file :tasting_notes

  validates_attachment_content_type :tasting_notes, :content_type => ['application/pdf', 'application/msword']     

  def delete_tasting_notes=(value)
    @delete_tasting_notes = !value.to_i.zero?
  end
  
   def delete_tasting_notes
     !!@delete_tasting_notes
   end
   alias_method :delete_tasting_notes?, :delete_tasting_notes
  
   def clear_tasting_notes
      self.tasting_notes.destroy if delete_tasting_notes?
   end
  
 	protected
   	def price_must_be_at_least_a_cent
       	errors.add(:price, 'should be at least 0.01') if !price.blank? &&
                          price < 0.01
  	end
      
  	def validate_attachments
     	errors.add_to_base("Too many attachments - maximum is #{Max_Attachments}") if pictures.length > Max_Attachments
    	pictures.each {|a| errors.add_to_base("#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB") if a.file_size > Max_Attachment_Size}
 	  end

end
