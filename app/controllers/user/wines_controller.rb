class User::WinesController < ApplicationController
  before_filter :authenticate_user!, :find_winery, :verify_ownership_status_is_user

  def new
    @wine = @winery.wines.new
  end

  def create
    @wine = @winery.wines.new(params[:wine])   

    if @wine.save
      flash[:notice] = "Successfully created wine."
      redirect_to wine_path(@wine)
    else
      flash[:notice] = "Error while creating wine."
      render :action => 'new'
    end
  end

  def edit
    @wine = @winery.wines.find(params[:id])
  end

  def update
    @wine = @winery.wines.find(params[:id])
    if @wine.update_attributes(params[:winery])
      flash[:notice] = "Successfully updated wine."
      redirect_to wine_path(@wine)
    else
      flash[:notice] = "Error while updating wine."
      render :action => 'edit'
    end
  end

  protected
    def find_winery
      @winery = Winery.find(params[:winery_id])
    end
    
    def verify_ownership_status_is_user
      if @winery.ownership_status == 'USER'
        true
      else
        flash[:notice] = "You cannot add wines to this winery."
        redirect_to winery_path(@winery)
      end
    end
    
end
