class FavoritesController < ApplicationController
#  before_filter :authenticate_user!

  def index
    @favorable = find_favorable
#    @favorites = @favorable.favorites
#    @favorites = current_user.favorites
    @favorites = Favorite.find_all_by_user_id(current_user.id)
  end
   
  def create
    @favorable = find_favorable
    @favorite = @favorable.favorites.build(params[:favorite])
    @favorite.user = current_user
    if @favorite.save
      flash[:notice] = @favorable.class.name + " successfully saved as favorite."
    else
      flash[:notice] = @favorite.errors.full_messages
    end
    respond_to do |format|
      format.html {redirect_to favorites_url}
      format.xml
      format.js
    end
    rescue
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
    flash[:alert] =  'You are not authorized to delete that favorite.'
    logger.error("Error when trying to destroy favorite #{params[:id]}.  Error message = " + e.message)
    redirect_to :action => "index"
  end

  def find_favorable
    params.each do |name, value|
       if name =~ /(.+)_id$/  
          return $1.classify.constantize.find(value)  
       end  
    end  
    nil  
  end
  
end
