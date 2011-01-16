class SpecialsController < ApplicationController
  before_filter :authenticate_winery!, :except => [:rating, :index, :show]
  before_filter :verify_winery_subscription, :except => [:rating, :all_wines, :show]

#  def rate
#    @special = Special.find(params[:id])
#    @special.rate(params[:stars], current_user, params[:dimension])
#    render :update do |page|
#      page.replace_html @special.wrapper_dom_id(params), ratings_for(@special, params.merge(:wrap => false))
#      page.visual_effect :highlight, @special.wrapper_dom_id(params)
#      # Update Upcoming Specials list with new result everytime user updates rating
##      @specials = Special.all(:order => "start_date DESC")
##      page.replace_html 'upcoming_specials', :partial => 'home/upcoming_specials',
##                                             :locals => {:upcoming_specials=>@specials }   
#    end
#  end

  def rating
    @special = Special.find(params[:id])
    @user_rating = @special.ratings.find_or_initialize_by_user_id(current_user.id)
    @user_rating.rate = params[:stars]
    if @user_rating.save
      flash[:notice] = "Successfully saved your rating."  
    end

    @specials = Special.upcoming_specials
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml
      format.js
    end
   
  end

  def index
#    @specials = Special.all
#    @specials = current_winery.specials
    if  current_winery
      @specials = current_winery.specials.paginate(:page => params[:page], :order => "created_at DESC")
    else  
      @specials = Special.all
    end
#    @event = Event.new(:winery_id => current_winery.id)
#    1.times {@event.pictures.build}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @specials }
      format.js
      format.mobile # show.mobile.erb
    end
 end
  
  def show
#    @special = Special.find(params[:id])
    @special = Special.find(params[:id])
  rescue
    flash[:notice] = 'You are not authorized to view that special.'
    redirect_to :action => "index"  
  end
  
  def new
    @special = Special.new(:winery_id => current_winery.id)
  end
  
  def create
    @special = Special.new(params[:special])
    @special.winery = current_winery

    if @special.save
      flash[:notice] = "Successfully created special."
      redirect_to specials_url
    else
      render :action => 'new'
    end
  end
  
  def edit
#    @special = Special.find(params[:id])
    @special = current_winery.specials.find(params[:id])
  rescue
    flash[:notice] = 'You are not authorized to edit that special.'
    redirect_to :action => "index"
  end
  
  def update
    @special = Special.find(params[:id])
    if @special.update_attributes(params[:special])
      flash[:notice] = "Successfully updated special."
      redirect_to specials_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @special = current_winery.specials.find(params[:id])
    @special.destroy
    flash[:notice] = "Successfully destroyed special."
    redirect_to specials_url
  rescue
    flash[:notice] = 'You are not authorized to delete that special.'
    redirect_to :action => "index"
  end
end
