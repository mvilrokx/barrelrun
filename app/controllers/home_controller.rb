class HomeController < ApplicationController
  def index
    @events = Event.upcoming_events.all
    @specials = Special.upcoming_specials.all
    @wines = Wine.top_wines.all
    @wineries = Winery.top_wineries.all # all(:order => "rating_average DESC", :limit => 10)
#    @wineries = Winery.all(:order => "average_rating DESC", :limit => 10)
#      @wineries = @wineries.sort_by(&:average_rating)
  end

  def all_objects_search
    with_params = params.select{|k,v| k=='vintage'||k=='average_rating'}
    with_params = Hash[*with_params.flatten]
    condition_params = params.select{|k,v| k=='winery_name'||k=='wine_name'||k=='wine_description'||k=='name'||k=='description'||k=='varietal'||k=='wine_type'}
    condition_params = Hash[*condition_params.flatten]
    if params[:class] then
	    @search_results = ThinkingSphinx.search(
		    params[:search],
		    :star => true,
		    :page => params[:page], 
		    :per_page => 10,
		    :with => with_params,
		    :conditions => condition_params,
		    :classes => [params[:class].classify.constantize]
	    )
      @search_result_facets = ThinkingSphinx.facets(
    		params[:search],
		    :star => true,
		    :page => params[:page], 
		    :per_page => 10,
		    :with => with_params,
		    :conditions => condition_params,
		    :classes => [params[:class].classify.constantize]
	    )
  	else
	    @search_results = ThinkingSphinx.search(
		    params[:search],
		    :star => true,
		    :page => params[:page], 
		    :per_page => 10,
		    :with => with_params,
		    :conditions => condition_params
	    )
      @search_result_facets = ThinkingSphinx.facets(
		    params[:search],
		    :star => true,
		    :page => params[:page], 
		    :per_page => 10,
		    :with => with_params,
		    :conditions => condition_params
	    )
    end	
  end
  
  def default_location
      if user_signed_in?
        unless current_user.lat.blank? || current_user.lng.blank? 
          @default_location = {'lat' => current_user.lat, 'lng' => current_user.lng}
        end
      elsif winery_signed_in?
        unless current_winery.lat.blank? || current_winery.lng.blank?
          @default_location = {'lat' => current_winery.lat, 'lng' => current_winery.lng}
        end
      end
      if @default_location.blank?
        @default_location = {'lat' => 38.3034, 'lng' => -122.2967} # Napa
#        @default_location = {'lat' => 51.226401, 'lng' => 5.302663} # Thuis (Lommel)
      end

      logger.info "set default location to: " + @default_location.to_s
      respond_to do |format|
        format.json  { render :json => @default_location }
      end
  end
  
  def upcoming_events
      @events = Event.upcoming_events.all
      respond_to do |format|
         format.html { render :partial=>"home/upcoming_events", :locals=>{:upcoming_events=>@events} }
         format.json { render :layout => false, :json => @events }
         format.js
      end
  end

  def upcoming_specials
      @specials = Special.upcoming_specials.all
      respond_to do |format|
         format.html { render :partial=>"home/upcoming_specials", :locals=>{:upcoming_specials=>@specials} }
         format.json { render :layout => false, :json => @specials }
         format.js
     end
  end

  def top_wines
      @wines = Wine.top_wines.all
      respond_to do |format|
         format.html { render :partial=>"home/top_wines", :locals=>{:top_wines=>@wines} }
         format.json { render :layout => false, :json => @wines }
         format.js { render :layout => false, :wines => @wines }
      end
  end

  def top_wineries
    @wineries = Winery.top_wineries.all # Winery.all(:order => "rating_average DESC", :limit => 10, :include => {:comments => :user})
#    @wineries = Winery.all(:order => "average_rating DESC", :limit => 10)
    respond_to do |format|
      format.html { render :partial=>"home/top_wineries", :locals=>{:top_wineries=>@wineries} }
      format.json { render :layout => false, :json => @wineries }
      format.js
    end
  end

  def local_wineries
      @wineries = Winery.find(:all)
      respond_to do |format|
         format.html 
         format.xml { render :text=>@wineries.to_xml(:only => [:lat, :lng, :winery_name],
                                                     :root => "data")
                    }
         format.js
     end
  end

end
