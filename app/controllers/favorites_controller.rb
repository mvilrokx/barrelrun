class FavoritesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @favorite_wines = current_user.favorite_wines.paginate(:page => params[:page], :order => "average_rating DESC")
    @favorite_wineries = current_user.favorite_wines.paginate(:page => params[:page], :order => "average_rating DESC")
    @favorite_events = current_user.favorite_events.paginate(:page => params[:page], :order => "average_rating DESC")
    @favorite_specials = current_user.favorite_specials.paginate(:page => params[:page], :order => "average_rating DESC")
  end
  
  def create
    @favorable = find_favorable
    @favorite = @favorable.favorites.build(params[:favorite])
    @favorite.user = current_user
    if @favorite.save
      flash[:notice] = @favorable.class.name + " successfully added to your favorites."
    else
      flash[:notice] = @favorite.errors.full_messages
    end
    respond_to do |format|
      format.html {redirect_to favorites_url}
      format.xml
      format.js
    end
    rescue Exception => e
      flash[:alert] =  'An error occured while you were creating this favorite.  We have been notified about this and will try to resolve the issue ASAP.'
      logger.error("Error when trying to create favorite #{params[:favorite]}.  Error message = " + e.message)
      redirect_to :action => "index"
  end

  def destroy
    @favorable = find_favorable
    @favorite = @favorable.favorites.find(params[:id])
    @favorite.destroy
    
    flash[:notice] = @favorable.class.name + " successfully removed from your favorites."
    respond_to do |format|
      format.html {redirect_to favorites_url}
      format.xml
      format.js
    end
    rescue Exception => e
      flash[:alert] =  'An error occured while you were removing this favorite.  We have been notified about this and will try to resolve the issue ASAP.'
      logger.error("Error when trying to destroy favorite #{params[:id]}.  Error message = " + e.message)
      redirect_to :action => "index"
  end

  def rate_it

    rate(params[:favorable_type], params[:favorable_id], params[:stars])
    if params[:favorable_type] == "Wine"
      favorite_wines
    elsif params[:favorable_type] == "Winery"
      favorite_wineries
    elsif params[:favorable_type] == "Event"
      favorite_events
    elsif params[:favorable_type] == "Special"
      favorite_specials
    end

  end

  def favorite_wineries
    @favorite_wineries = current_user.favorite_wineries.paginate(:page => params[:page], :order => "average_rating DESC")
    respond_to do |format|
      format.html { render :partial=>"favorites_list", :object => @favorite_wineries }
    end
  end
  
  def favorite_wines
    @favorite_wines = current_user.favorite_wines.paginate(:page => params[:page], :order => "average_rating DESC")
    respond_to do |format|
      format.html { render :partial=>"favorites_list", :object => @favorite_wines }
    end
  end

  def favorite_events
    @favorite_events = current_user.favorite_events.paginate(:page => params[:page], :order => "average_rating DESC")
    respond_to do |format|
      format.html { render :partial=>"favorites_list", :object => @favorite_events }
 #     format.html { render :partial=>"events_list", :locals=>{:events=>@favorite_events} }
    end
  end

  def favorite_specials
    @favorite_specials = current_user.favorite_specials.paginate(:page => params[:page], :order => "average_rating DESC")
    respond_to do |format|
      format.html { render :partial=>"favorites_list", :object => @favorite_specials }
#      format.html { render :partial=>"specials_list", :locals=>{:events=>@favorite_specials} }
    end
  end

#  def rating
#    favorite = Favorite.find(params[:id])
##    favorite = Favorite.find(favorable_type = "Wine" and favorable_id = params[:id])
#    rate(favorite.favorable_type, favorite.favorable_id, params[:stars])
#    if favorite.favorable_type == "Wine"
#      render :action => favorite_wines
#    end

##    @wines = Wine.top_wines.all
##    respond_to do |format|
##      format.html # index.html.erb
##      format.xml
##      format.js
##    end
#  end

  private
  
    def find_favorable
      params.each do |name, value|
         if name =~ /(.+)_id$/  
            return $1.classify.constantize.find(value)  
         end  
      end  
      nil  
    end
 
end
