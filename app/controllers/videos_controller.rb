class VideosController < ApplicationController
  before_filter :authenticate_winery!, :except => [:show, :index_yt]
  before_filter :verify_winery_subscription, :except => [:show, :index_yt]
  before_filter :get_and_authorize_client

  def show
    @video = Video.find(params[:id])
    # do security check here
#    send_file video.data.path, :type => video.content_type
  end
    
  def index_yt
#    client = YouTubeIt::OAuthClient.new(YOUTUBE_CONFIG)
#    winery_auth = current_winery.authentications.first(:conditions => ["provider = ?", "you_tube"])
#    client.authorize_from_access(winery_auth.access_token, winery_auth.access_secret)
#    client.add_comment('cGKrBGMiH-I', 'test')
    @videos = @client.videos_by(:user => @client.current_user)
  end

  def index
    @videos = current_winery.videos.paginate(:page => params[:page], :order => "created_at DESC")
  end

  def new
    @video = Video.new(:videoable_id => current_winery.id, 	:videoable_type => 'Winery')
  end

  def create
    @video = Video.new(params[:video])

    if @video.save
      flash[:notice] = "Successfully created video."
      redirect_to videos_url
    else
      render :action => 'new'
    end
  end

  def make_primary
    @video = current_winery.videos.find(params[:id])
    @video.primary = true
# TODO: Set ALL OTHER ONES TO FALSE~!!!!!!    
    if @video.save
      flash[:notice] = "Successfully made video your welcome video."
    else
      flash[:notice] = "Could not make video your welcome video."
    end
    redirect_to videos_url
  end

  def destroy
    @video = current_winery.videos.find(params[:id])
    @video.destroy
    flash[:notice] = "Successfully destroyed video."
    redirect_to specials_url
  rescue
    flash[:notice] = 'You are not authorized to delete that video.'
    redirect_to :action => "index"
  end
  
  protected
    def get_and_authorize_client
      @client = YouTubeIt::OAuthClient.new(YOUTUBE_CONFIG)
      @winery_auth = current_winery.authentications.first(:conditions => ["provider = ?", "you_tube"])
      @client.authorize_from_access(@winery_auth.access_token, @winery_auth.access_secret)
    end  
end
