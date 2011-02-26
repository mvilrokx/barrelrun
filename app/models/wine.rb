class Wine < ActiveRecord::Base

 	has_many :comments, :as => :commentable, :dependent => :destroy, :order => "created_at DESC"
 	has_many :favorites, :as => :favorable, :dependent => :destroy
#    accepts_nested_attributes_for :favorites, :allow_destroy => true
 	has_many :pictures, :as => :pictureable, :dependent => :destroy
  has_many :ratings, :as => :rateable, :dependent => :destroy
  has_many :awards, :dependent => :destroy

  accepts_nested_attributes_for :pictures, :reject_if => lambda {|a| a[:photo].blank? }, :allow_destroy => true
 
 	belongs_to :winery
 
#  	before_validation :clear_picture

  validates_presence_of :name, :wine_type, :vintage, :varietal
 	validates_numericality_of :price, :vintage, :allow_blank => true
 	validate :price_must_be_at_least_a_cent, :validate_attachments
 	validates_associated :favorites

  before_validation :clear_tasting_notes
  #Controls the number of wines you see per page (pagination)
  cattr_reader :per_page
  @@per_page = 10
  #Controls the size of Top List
  cattr_reader :top_list_size
  @@top_list_size = 10

  Max_Attachments = 5
  Max_Attachment_Size = 5.megabyte


#  ajaxful_rateable :stars => 5, :allow_update => true, :dimensions => [:overall]

#  named_scope :top_wines, :order => "average_rating DESC", :include => {:comments => :user}
  named_scope :top_wines, lambda { |top|
      { :limit => top||=:top_list_size, :order => "average_rating DESC" }
#    if top.nil?
#      { :limit => 10, :order => "average_rating DESC" }
#    else
#      { :limit => top, :order => "average_rating DESC" }
#    end
    }   

#  named_scope :top_wines, :order => "average_rating DESC", 
#                          :limit => 10,
#                          :include => {:comments => :user}
   
  named_scope :distinct_wine_types, :select => "distinct wine_type",
                                   :order => "wine_type"
  named_scope :distinct_varietals, :select => "distinct varietal",
                                   :order => "varietal"

  # ThinkingSphinx setup
  define_index do
    indexes :name
    indexes description
    indexes varietal, :facet => true
    indexes wine_type, :facet => true
    
    has vintage, average_rating, :facet => true
  end
  
  has_attached_file :tasting_notes

  validates_attachment_content_type :tasting_notes, :content_type => ['application/pdf', 'application/msword']     

#   	has_attached_file :picture, 
#                      :styles => {:thumb => "100x100>",
#                                  :small => "300x300>",
#                                  :large => "600x600>"
#                                 },  
#                      :url => "/assets/wines/:id/:style/:basename.:extension",  
#                      :path => ":rails_root/public/assets/wines/:id/:style/:basename.:extension"
 
#   validates_attachment_size :photo, :less_than => 5.megabytes  
#   validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']     
   
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
