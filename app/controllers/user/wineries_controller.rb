class User::WineriesController < ApplicationController
  before_filter :authenticate_user! , :except => [:claim, :update_claim]
  before_filter :verify_winery_is_not_claimed, :except => [:new, :create]

  def new
    @winery = Winery.new
  end

  def create
    @winery = Winery.new(params[:winery])
    o =  [(0..9),('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    # Random Username and PWD
    @winery.username  =  (0..19).map{ o[rand(o.length)]  }.join
    @winery.password  =  (0..19).map{ o[rand(o.length)]  }.join
    @winery.password_confirmation = @winery.password
    # Default other values
    @winery.contact_first_name = "CHANGE_ME"
    @winery.contact_last_name = "CHANGE_ME"
    @winery.telephone = "555-5555-555" if params[:winery][:telephone].blank?
    @winery.website_url = "http://barrelrun.com" if params[:winery][:website_url].blank?
    @winery.email = (0..19).map{ o[rand(o.length)]  }.join + "@CHANGE_ME.COM"
    @winery.ownership_status = 'USER'

    if @winery.save
      flash[:notice] = "Successfully created winery."
      redirect_to winery_path(@winery)
    else
      flash[:notice] = "Error while creating winery."
      render :action => 'new'
    end
#    @winery.skip_confirmation!
  end

  def edit
    @winery = Winery.find(params[:id])
  end

  def update
    @winery = Winery.find(params[:id])
    @winery.website_url = "http://www.barrelrun.com" if params[:winery][:website_url].blank?
    if @winery.update_attributes(params[:winery])
      flash[:notice] = "Successfully updated winery."
      redirect_to winery_path(@winery)
    else
      flash[:notice] = "Error while updating winery."
      render :action => 'edit'
    end
  end

  def claim
    @winery = Winery.find(params[:id])
  end

  def update_claim
    @winery = Winery.find(params[:id])
    @winery.ownership_status = 'CLAIMED'
    if @winery.update_attributes(params[:winery])
#      sign_in winery_name, @winery, :bypass => true
      @winery.send_confirmation_instructions
      flash[:notice] = "You will receive an email with instructions about how to confirm your account in a few minutes."
      redirect_to winery_path(@winery)
    else
      flash[:notice] = "Error while claiming winery."
      render :action => 'claim'
    end
  end

  protected
    
    def verify_winery_is_not_claimed
      if Winery.find(params[:id]).ownership_status != 'CLAIMED'
        true
      else
        flash[:notice] = "You cannot edit this winery."
        redirect_to winery_path(@winery)
      end
    end

end
