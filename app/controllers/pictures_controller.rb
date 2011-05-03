class PicturesController < ApplicationController
  before_filter :authenticate_winery!, :except => [:show]
  before_filter :verify_winery_subscription

  def show
    @picture = Picture.find(params[:id])
  # do security check here
  # send_file picture.data.path, :type => picture.content_type
  end
    
  def index
    @pictures = current_winery.pictures.paginate(:page => params[:page], :order => "created_at DESC")
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
    flash[:notice] = "Successfully destroyed picture."
    redirect_to specials_url
  rescue
    flash[:notice] = 'You are not authorized to delete that picture.'
    redirect_to :action => "index"
  end


end
