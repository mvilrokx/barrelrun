class RatingsController < ApplicationController

  def index
    @ratings = Rating.all
  end
  
  def show
    @rating = Rating.find(params[:id])
  end
  
  def new
    @rating = Rating.new
  end
  
  def create
    @rating = Rating.new(params[:rating])
    if @rating.save
      flash[:notice] = "Successfully created rating."
      redirect_to @rating
    else
      render :action => 'new'
    end
  end
  

  def create  
    @rateable = find_rateable
    @user_rating = @rateable.ratings.find_or_initialize_by_user_id(current_user.id)
    @user_rating.rate = params[:stars]

    if @user_rating.save
      flash[:notice] = "Successfully saved your rating."
    end
#    @wines = Wine.top_wines.all
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml
#      format.js
#    end
  end


  def edit
    @rating = Rating.find(params[:id])
  end
  
  def update
    @rating = Rating.find(params[:id])
    if @rating.update_attributes(params[:rating])
      flash[:notice] = "Successfully updated rating."
      redirect_to @rating
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @rating = Rating.find(params[:id])
    @rating.destroy
    flash[:notice] = "Successfully destroyed rating."
    redirect_to ratings_url
  end

  def find_rateable
    params.each do |name, value|  
       if name =~ /(.+)_id$/  
          return $1.classify.constantize.find(value)
       end  
    end  
    nil
  end  

end
