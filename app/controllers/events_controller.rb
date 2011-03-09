class EventsController < ApplicationController
  before_filter :authenticate_winery!, :except => [:index, :rating, :show]
  before_filter :verify_winery_subscription, :except => [:index, :rating, :show]
  
  def rating
    rate("Event", params[:id], params[:stars])
    event_list
  end

  def event_list
    ordered_list = false
    list_header = "Events"
    if params[:winery_id]
      @events = Winery.find(params[:winery_id]).events #.paginate(:page => params[:page], :include => [:pictures], :order => "specials.updated_at DESC")
      path = "wineries/" + params[:winery_id] + "/"
    elsif params[:top]
      @events = Event.upcoming_events(params[:top]) #.all(:limit => params[:top])
      list_header = "Places to Go"
      path = "top/" + params[:top] + "/"
    else
      @events = Event.all.paginate(:page => params[:page], :include => [:pictures], :order => "updated_at DESC")
    end
    respond_to do |format|
      format.html { render :partial=>"shared/object_list", :locals => {:object_list => @events,
                                                                       :path => path,
                                                                       :ordered_list => ordered_list,
                                                                       :list_header => list_header } }
      format.json { render :layout => false, :json => @events }
    end
  end

  
#  def upcoming_events
#    @events = Events.upcoming_events.all.paginate(:page => params[:page])
#    respond_to do |format|
#      format.html { render :partial=>"shared/object_list", :locals => {:object_list => @events, 
#                                                                       :list_header => "Places to Go" } }
#      format.json { render :layout => false, :json => @events }
#    end
#  end

  def index
#    if current_winery
      @events = current_winery.events.paginate(:page => params[:page], :order => "created_at DESC")
#    else  
#      @events = Event.all.paginate(:page => params[:page], :order => "created_at DESC")
#    end

    if request.xml_http_request?
      render :partial => "events", :layout => false
    else
      respond_to do |format|
        format.html
        format.js
        format.mobile
      end
    end
  end

  def show
    @event = Event.find(params[:id], :include => [{:comments => {:user => :picture}}, :pictures])
    rescue Exception => e
      flash[:notice] =  'An error occured while trying to show this event.  We have been notified about this and will try to resolve the issue ASAP.'
      logger.error("Error when trying to show event #{params[:id]}.  Error message = " + e.message)
      redirect_to :action => "index"
  end
  
  def new
    @event = current_winery.events.new
  end
  
  def create
    @event = current_winery.events.new(params[:event])
    if @event.save
      flash[:notice] = 'Successfully created event.'
      Juggernaut.publish("channel1", current_winery.winery_name.to_s + " added a new event called " + @event.name.to_s) rescue nil
      redirect_to events_url
    else
      render :action => "new"
    end
  end
  
  def edit
    @event = current_winery.events.find(params[:id])
    rescue Exception => e
      flash[:notice] =  'An error occured while trying to edit this event.  We have been notified about this and will try to resolve the issue ASAP.'
      logger.error("Error when trying to edit event #{params[:id]}.  Error message = " + e.message)
      redirect_to :action => "index"
  end
  
  def update
    @event = current_winery.events.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = "Successfully updated event."
      redirect_to events_url
    else
      render :action => 'edit'
    end
    rescue Exception => e
      flash[:notice] =  'An error occured while trying to edit this event.  We have been notified about this and will try to resolve the issue ASAP.'
      logger.error("Error when trying to edit event #{params[:id]}.  Error message = " + e.message)
      redirect_to :action => "index"
  end
  
  def destroy
    @event = current_winery.events.find(params[:id])
    @event.destroy
    flash[:notice] = "Successfully destroyed event."
    redirect_to events_url
    rescue Exception => e
      flash[:notice] =  'An error occured while trying to delete this event.  We have been notified about this and will try to resolve the issue ASAP.'
      logger.error("Error when trying to delete event #{params[:id]}.  Error message = " + e.message)
      redirect_to :action => "index"
  end
end
