class WineriesController < ApplicationController
  before_filter :authenticate_winery!, :except => [:rate, :rating, :index, :show]
  
  def index
    @wineries = Winery.all;
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :layout => false, :json => @wineries }
      format.mobile # show.mobile.erb
    end
  end
  
  def index_pics
    @winery_pics = current_winery.pictures
  end

  # GET /wineries/1
  # GET /wineries/1.xml
  def show
    @winery = Winery.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @winery }
	  format.mobile # show.mobile.erb
    end
  end

#  def rate
#    @winery = Winery.find(params[:id])
#    @winery.rate(params[:stars], current_user, params[:dimension])
#    render :update do |page|
#      page.replace_html @winery.wrapper_dom_id(params), ratings_for(@winery, params.merge(:wrap => false))
#      page.visual_effect :highlight, @winery.wrapper_dom_id(params)
#      # Update Top Wineries list with new result everytime user updates rating
#      @wineries = Winery.all(:order => "rating_average DESC")
#      page.replace_html 'top_wineries', :partial => 'home/top_wineries',
#                                        :locals => {:top_wineries=>@wineries }   
#    end
#  end

  def rating
    @winery = Winery.find(params[:id])
    @user_rating = @winery.ratings.find_or_initialize_by_user_id(current_user.id)
    @user_rating.rate = params[:stars]
    if @user_rating.save
      flash[:notice] = "Successfully saved your rating."  
    end
    @wineries = Winery.top_wineries.all

#    @wineries = Winery.top_wineries.all
#    @wineries = Winery.all.sort_by(&:calc_average_rating)
    
#    @wineries = @wineries.sort_by(&:calc_average_rating)
    respond_to do |format|
      format.html # index.html.erb
      format.xml
      format.js {render :layout => false}
    end
   
  end

end
