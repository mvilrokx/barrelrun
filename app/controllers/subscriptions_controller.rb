class SubscriptionsController < ApplicationController
  def index
    @subscription = current_winery.subscription
    if @subscription
      redirect_to @subscription
    else
      @subscription = Subscription.new
      render :action => 'new'
    end
  end
  
  def show
    @subscription = current_winery.subscription
  end
  
  def new
    @subscription = Subscription.new
  end
  
  def create
    @subscription = Subscription.new(params[:subscription])
    @subscription.winery_id = current_winery.id
    if @subscription.save
      flash[:notice] = "Successfully created subscription."
      redirect_to @subscription
    else
      render :action => 'new'
    end
  end
  
  def edit
    @subscription = current_winery.subscription
  end
  
  def update
    @subscription = current_winery.subscription
    if @subscription.update_attributes(params[:subscription])
      flash[:notice] = "Successfully updated subscription."
      redirect_to @subscription
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @subscription = current_winery.subscription.destroy
    flash[:notice] = "Successfully destroyed subscription."
    render :action => 'edit'
#    redirect_to subscription_url
  end
end
