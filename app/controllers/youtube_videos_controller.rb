class YoutubeVideosController < ApplicationController
  before_filter :authenticate_winery!
  before_filter :verify_winery_subscription
  before_filter :get_and_authorize_client

  def show
    @video = @client.video_by(params[:id])
  end
    
  def index
    @videos = @client.videos_by(:user => @client.current_user, :page => params[:page]||1, :per_page => params[:per_page]||10)
  end

  def upload
  end

  def new
    @upload_info = @client.upload_token({:title => params[:title],
                                         :description => params[:description],
                                         :keywords => %w[params[:keywords]],
                                         :dev_tag => "barrelrun.com",
                                         :category => "People"},
                                         youtube_videos_url)
  end

  def add_to_winery_details
    current_winery.videos.find_or_create_by_youtube_id(params[:id])
    flash[:notice] = "Successfully added video to Winery Details page."
    redirect_to :action => "index"
  end

  def remove_from_winery_details
    @video = current_winery.videos.find_by_youtube_id(params[:id])   
    @video.destroy
    flash[:notice] = "Successfully removed video from Winery Details page."
    redirect_to :action => "index"
  rescue
    flash[:notice] = 'You are not authorized to delete that video.'
    redirect_to :action => "index"
  end

  def make_primary
    @video = current_winery.videos.find_by_youtube_id(params[:id])
    @video.welcome = true
    if @video.save
      flash[:notice] = "Successfully made video your welcome video."
    else
      flash[:notice] = "Could not make video your welcome video."
    end
    redirect_to :action => "index"
  end

  def destroy
    @client.video_delete(params[:id])
    flash[:notice] = "Successfully removed video."
    redirect_to :action => "index"
  rescue
    flash[:notice] = 'You are not authorized to delete that video.'
    redirect_to :action => "index"
  end
  
  protected
    def get_and_authorize_client
      @client = YouTubeIt::OAuthClient.new(YOUTUBE_CONFIG)
      @winery_auth = current_winery.authentications.first(:conditions => ["provider = ?", "you_tube"])
#      @winery_auth = current_winery.authentications.where("provider = ?", "you_tube")
#      ap @winery_auth
      if @winery_auth
        @client.authorize_from_access(@winery_auth.access_token, @winery_auth.access_secret)
      else
        redirect_to '/auth/you_tube'
      end
    end
end
