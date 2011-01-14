class EventsController < ApplicationController
  before_filter :authenticate_winery!, :except => [:rate, :index, :rating, :show]
  before_filter :verify_winery_subscription
  
  def rate
    @event = Event.find(params[:id])
    @event.rate(params[:stars], current_user, params[:dimension])
    render :update do |page|
      page.replace_html @event.wrapper_dom_id(params), ratings_for(@event, params.merge(:wrap => false))
      page.visual_effect :highlight, @event.wrapper_dom_id(params)
      # Update Upcoming Events list with new result everytime user updates rating
#      @events = Event.all(:order => "rating_average DESC", :include => :comments)
#      page.replace_html 'upcoming_events', :partial => 'home/upcoming_events',
#                                           :locals => {:upcoming_events=>@events }   
    end
  end

  def rating
    @event = Event.find(params[:id])
    @user_rating = @event.ratings.find_or_initialize_by_user_id(current_user.id)
    @user_rating.rate = params[:stars]
    if @user_rating.save
      flash[:notice] = "Successfully saved your rating."
    end
    @events = Event.upcoming_events.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml
      format.js
    end
 
  end

  def index
#    @events = Event.all
    if  current_winery
      @events = current_winery.events.paginate(:page => params[:page], :order => "created_at DESC")
    else  
      @events = Event.all
    end

#    @event = Event.new(:winery_id => current_winery.id)
#    1.times {@event.pictures.build}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.js
      format.mobile
    end
  end

  def show
#    @event = Event.find(params[:id])
    @event = Event.find(params[:id])
    rescue
      flash[:alert] = 'You are not authorized to view that event.'
      redirect_to :action => "index"
  end
  
  def new
    @event = Event.new(:winery_id => current_winery.id)
#    3.times {@event.pictures.build}
  end
  
  def create
    @event = Event.new(params[:event])
#    @event = Event.create!(params[:event])
#    @event.winery = current_winery
    if @event.save
      flash[:notice] = "Successfully created event."
       @events = current_winery.events
#      redirect_to @event
#      redirect_to events_url
      respond_to do |format|
         format.html {redirect_to events_url}
         format.js
       end  
    else
      render :action => 'new'
    end
  end
  
  def edit
#    @event = Event.find(params[:id])
    @event = current_winery.events.find(params[:id])
#    3.times { @event.pictures.build }
#    render :update do |page|
#        page.replace_html 'entry_form', :partial => 'new_event',
#                                        :locals => {:event=>@event }
#    end                                        
  rescue Exception => e
      logger.error("Error when trying to edit event #{params[:id]}.  Error message = " + e.message)
      flash[:alert] = 'You are not authorized to edit that event.'
      redirect_to :action => "index"
  end
  
  def update
    @event = Event.find(params[:id])
#    @event = current_winery.event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = "Successfully updated event."
      redirect_to events_url
    else
      render :action => 'edit'
    end
  rescue
      flash[:alert] = 'You are not authorized to update that event.'
      redirect_to :action => "index"
  end
  
  def destroy
    @event = current_winery.events.find(params[:id])
    @event.destroy
    flash[:notice] = "Successfully destroyed event."
    redirect_to events_url
  rescue Exception => e
    flash[:alert] =  'You are not authorized to delete that event.'
    logger.error("Error when trying to destroy event #{params[:id]}.  Error message = " + e.message)
    redirect_to :action => "index"
  end
end
