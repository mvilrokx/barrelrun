class AwardsController < ApplicationController
  def index
#    @awards = Award.all
    @awards = current_winery.awards.paginate(:page => params[:page])
  end
  
  def show
    @award = current_winery.awards.find(params[:id])
  end
  
  def new
    @award = Award.new
  end
  
  def create
    @award = Award.new(params[:award])
    if @award.save
      flash[:notice] = "Successfully created award."
      @awards = current_winery.awards
      respond_to do |format|
         format.html {redirect_to awards_url}
         format.js
       end
    else
      render :action => 'new'
    end
  end
  
  def edit
    @award = current_winery.awards.find(params[:id])
  end
  
  def update
    @award = Award.find(params[:id])
    if @award.update_attributes(params[:award])
      flash[:notice] = "Successfully updated award."
      redirect_to awards_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @award = current_winery.awards.find(params[:id])
    @award.destroy
    flash[:notice] = "Successfully destroyed award."
    redirect_to awards_url
  end
end
