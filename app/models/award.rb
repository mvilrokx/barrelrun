class Award < ActiveRecord::Base
  has_many :pictures, :as => :pictureable, :dependent => :destroy
  belongs_to :wine

  accepts_nested_attributes_for :pictures, :reject_if => lambda {|a| a[:photo].blank? }, :allow_destroy => true  

  validates_presence_of :title, :wine

  cattr_reader :per_page
  @@per_page = 10

  Max_Attachments = 5
  Max_Attachment_Size = 5.megabyte

  protected

    def validate_attachments
     	errors[:base] << "Too many attachments - maximum is #{Max_Attachments}" if pictures.length > Max_Attachments
	    pictures.each {|a| errors[:base] << "#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB" if a.file_size > Max_Attachment_Size}
    end

end
