class AuthenticationsController < ApplicationController
  before_filter :authenticate_winery!

  def index
    @authentications = current_winery.authentications if current_winery
  end
  
  def create
    auth = request.env["omniauth.auth"]
    Authentication.find_or_create_by_provider_and_uid_and_winery_id(:provider => auth['provider'],
                                          :uid => auth['uid'],
                                          :winery_id => current_winery.id,
                                          :access_token => auth['credentials']['token'],
                                          :access_secret => auth['credentials']['secret'] )
    flash[:notice] = "Authentication successfull"
    redirect_to youtube_videos_url
  end
  
  def destroy
    @authentication = current_winery.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
