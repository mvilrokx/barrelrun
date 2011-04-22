class User::WineriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_ownership_status_is_user, :except => [:new, :create]

  def new
    @winery = Winery.new
  end

  def create
    @winery = Winery.new(params[:winery])
    o =  [(0..9),('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    # Random Username
    @winery.username  =  (0..19).map{ o[rand(o.length)]  }.join
    @winery.contact_first_name = "CHANGE_ME"
    @winery.contact_last_name = "CHANGE_ME"
    @winery.telephone = "555-5555-555" if params[:winery][:telephone].blank?
    @winery.website_url = "http://barrelrun.com" if params[:winery][:website_url].blank?
    @winery.email = (0..19).map{ o[rand(o.length)]  }.join + "@CHANGE_ME.COM"
    # Random PWD
    @winery.password  =  (0..19).map{ o[rand(o.length)]  }.join
    @winery.password_confirmation = @winery.password
    @winery.ownership_status = 'USER'

    if @winery.save
      flash[:notice] = "Successfully created winery."
      redirect_to winery_path(@winery)
    else
      flash[:notice] = "Error while creating winery."
      render :action => 'new'
    end
  end

  def edit
    @winery = Winery.find(params[:id])
  end

  def update
    @winery = Winery.find(params[:id])
    @winery.website_url = "http://barrelrun.com" if params[:winery][:website_url].blank?
    if @winery.update_attributes(params[:winery])
      flash[:notice] = "Successfully updated winery."
      redirect_to winery_path(@winery)
    else
      flash[:notice] = "Error while updating winery."
      render :action => 'edit'
    end
  end

  protected
    
    def verify_ownership_status_is_user
      if Winery.find(params[:winery_id]).ownership_status == 'USER'
        true
      else
        flash[:notice] = "You cannot edit this winery."
        redirect_to winery_path(@winery)
      end
    end

end
