class PicturesController < ApplicationController
  before_filter :authenticate_winery!, :except => [:show]
  before_filter :verify_winery_subscription

  def show
    @picture = Picture.find(params[:id])
  # do security check here
  # send_file picture.data.path, :type => picture.content_type
  end

  def index
    @pictures = current_winery.pictures.paginate(:page => params[:page], , :per_page => params[:per_page], :order => "created_at DESC")
  end

  def new
    @picture = Picture.new(:pictureable_id => current_winery.id, 	:pictureable_type => 'Winery')
  end

  def create
    @picture = Picture.new(params[:picture])

    if @picture.save
      flash[:notice] = "Successfully created picture."
      redirect_to pictures_url
    else
      render :action => 'new'
    end
  end

  def destroy
    @picture = current_winery.pictures.find(params[:id])
    @picture.destroy
    render :json => @picture.errors
    rescue Exception => e
      flash[:notice] =  'An error occured while trying to delete this picture.  We have been notified about this and will try to resolve the issue ASAP.'
      logger.error("Error when trying to delete picture #{params[:id]}.  Error message = " + e.message)
      redirect_to :action => "index"
  end

end

