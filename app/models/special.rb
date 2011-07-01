class Special < ActiveRecord::Base
  has_many :comments, :as => :commentable #, :dependent => :destroy
  has_many :pictures, :as => :pictureable, :dependent => :destroy
  has_many :ratings, :as => :rateable #, :dependent => :destroy
 	has_many :favorites, :as => :favorable, :dependent => :destroy

  accepts_nested_attributes_for :pictures, :reject_if => lambda {|a| a[:photo].blank? }, :allow_destroy => true

  belongs_to :winery

  #   before_validation :clear_picture

  #   attr_accessible :title, :description, :start_date, :end_date, :winery_id

  #Controls the number of wines you see per page (pagination)
  cattr_reader :per_page
  @@per_page = 10
  #Controls the size of Top List
  cattr_reader :top_list_size
  @@top_list_size = 10

  Max_Attachments = 5
  Max_Attachment_Size = 5.megabyte

  # ajaxful_rateable :stars => 5, :allow_update => true, :dimensions => [:overall]

  validates_presence_of :title
  validate :validate_attachments
  before_destroy :check_for_comments_or_ratings

  named_scope :upcoming_specials, lambda { |*top|
    if top.empty? || top.first.nil?
      { :conditions => ["end_date >= :today", {:today => Date.today}],
        :order => "start_date DESC"
      }
    else
      { :limit => top[0],
        :conditions => ["end_date >= :today", {:today => Date.today}],
        :order => "start_date DESC"
      }
    end
  }

#  named_scope :upcoming_specials, :conditions => ["end_date >= :today", {:today => Date.today}],
#                          :order => "start_date DESC",
#                          :limit => 10,
#                          :include => {:comments => :user}

#   has_attached_file :picture,
#                     :styles => {:thumb => "100x100>",
#                                 :small => "300x300>",
#                                 :large => "600x600>"
#                                 },
#                     :url => "/assets/specials/:id/:style/:basename.:extension",
#                     :path => ":rails_root/public/assets/specials/:id/:style/:basename.:extension"
#
#   validates_attachment_size :photo, :less_than => 5.megabytes
#   validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
#
#   def delete_picture=(value)
#      @delete_picture = !value.to_i.zero?
#   end
#
#   def delete_picture
#     !!@delete_picture
#   end
#   alias_method :delete_picture?, :delete_picture
#
#   def clear_picture
#      self.picture = nil if delete_picture?
#   end

  def name
    title
  end

 	protected
  	def validate_attachments
     	errors.add_to_base("Too many attachments - maximum is #{Max_Attachments}") if pictures.length > Max_Attachments
    	pictures.each {|a| errors.add_to_base("#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB") if a.file_size > Max_Attachment_Size}
    end
    def check_for_comments_or_ratings
      if comments.count > 0 || ratings.count > 0
        errors.add_to_base("You cannot delete this object because users have already commented on it or rated it.")
        return false
      end
    end
end

