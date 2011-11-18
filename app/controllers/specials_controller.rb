class SpecialsController < ApplicationController
  before_filter :authenticate_winery!, :except => [:rating, :special_list, :index, :show]
  before_filter :verify_winery_subscription, :except => [:rating, :special_list, :index, :show]

  def rating
    rate("Special", params[:id], params[:stars])
    special_list
  end


  def special_list
    ordered_list = false
    list_header = "Specials"
    if params[:winery_id]
      @specials = Winery.find(params[:winery_id]).specials #.paginate(:page => params[:page], :include => [:pictures], :order => "specials.updated_at DESC")
      path = "wineries/" + params[:winery_id] + "/"
    elsif params[:top]
      @specials = Special.upcoming_specials(params[:top]) #.all(:limit => params[:top])
      list_header = "Save Money"
      path = "top/" + params[:top] + "/"
    else
      @specials = Special.all.paginate(:page => params[:page], :include => [:pictures], :order => "updated_at DESC")
    end
    respond_to do |format|
      format.html { render :partial=>"shared/object_list", :locals => {:object_list => @specials,
                                                                       :path => path,
                                                                       :ordered_list => ordered_list,
                                                                       :list_header => list_header } }
      format.json { render :layout => false,
                           :json => @specials.to_json(:include => { :pictures => { :only => [:id, :photo_file_name] } } )
                  }
    end
  end


#  def upcoming_specials
#    @specials = Special.upcoming_specials.all.paginate(:page => params[:page])
#    respond_to do |format|
#      format.html { render :partial=>"shared/object_list", :locals => {:object_list => @specials,
#                                                                       :list_header => "Save Money" } }
#      format.json { render :layout => false, :json => @specials }
##      format.js { render :layout => false, :wines => @wines }
#    end
#  end

  def index
    if current_winery
      @specials = current_winery.specials.paginate(:page => params[:page], :order => "created_at DESC")
    else
#      @specials = Special.all.paginate(:page => params[:page], :order => "created_at DESC")
      @search = Special.searchlogic(params[:search])
      @specials = @search.all.paginate(:page => params[:page], :per_page => params[:per_page])
    end
    if request.xml_http_request?
      render :partial => "specials", :layout => false
    else
      respond_to do |format|
        format.html # index.html.erb
  #      format.xml  { render :xml => @specials }
        format.js
        format.mobile
        format.json { render :layout => false,
                           :json => @specials.to_json(:include => { :pictures => { :only => [:id, :photo_file_name] } } )
                  }
      end
    end
  end

  def show
    @special = Special.find(params[:id], :include => [{:comments => {:user => :picture}}, :pictures])
    rescue Exception => e
      flash[:notice] =  'An error occured while trying to show this special.  We have been notified about this and will try to resolve the issue ASAP.'
      logger.error("Error when trying to show special #{params[:id]}.  Error message = " + e.message)
      redirect_to :action => "index"
  end

  def new
    @special = current_winery.specials.new
  end

  def create
    @special = current_winery.specials.new(params[:special])

    if @special.save
      flash[:notice] = 'Successfully created special.'
      Juggernaut.publish("channel1", "#{current_winery.winery_name.to_s} added a new special called <a href='/specials/#{@special.id}' class='dialog_form_link'>#{@special.name.to_s}</a>") rescue nil

      redirect_to specials_url
    else
      render :action => "new"
    end
  end

  def edit
    @special = current_winery.specials.find(params[:id])
    rescue Exception => e
      flash[:notice] =  'An error occured while trying to edit this special.  We have been notified about this and will try to resolve the issue ASAP.'
      logger.error("Error when trying to edit special #{params[:id]}.  Error message = " + e.message)
      redirect_to :action => "index"
  end

  def update
    @special = current_winery.specials.find(params[:id])
    if @special.update_attributes(params[:special])
      flash[:notice] = "Successfully updated special."
      redirect_to specials_url
    else
      render :action => 'edit'
    end
    rescue Exception => e
      flash[:notice] =  'An error occured while trying to edit this special.  We have been notified about this and will try to resolve the issue ASAP.'
      logger.error("Error when trying to edit special #{params[:id]}.  Error message = " + e.message)
      redirect_to :action => "index"
  end

  def destroy
    @special = current_winery.specials.find(params[:id])
    @special.destroy
    render :json => @special.errors
#    flash[:notice] = "Successfully destroyed special."
#    redirect_to specials_url
    rescue Exception => e
      flash[:notice] =  'An error occured while trying to delete this special.  We have been notified about this and will try to resolve the issue ASAP.'
      logger.error("Error when trying to delete special #{params[:id]}.  Error message = " + e.message)
      redirect_to :action => "index"
  end
end

