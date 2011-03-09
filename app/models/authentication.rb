class Authentication < ActiveRecord::Base
  belongs_to :winery
#  attr_accessible :winery_id, :provider, :uid, :access_token, :access_secret
end
