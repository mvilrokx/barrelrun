class VideosController < ApplicationController
  before_filter :authenticate_winery!, :except => [:show]

  def show
    @video = Video.find(params[:id])
    # do security check here
#    send_file video.data.path, :type => video.content_type
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
end
