class CreditCardsController < ApplicationController
  before_filter :authenticate_winery!

  def index
    @credit_cards = current_winery.credit_cards.paginate(:page => params[:page], :order => "created_at DESC")
  end
  
  def show
    @credit_card = current_winery.credit_cards.find(params[:id])
  end
  
  def new
    @credit_card = CreditCard.new
  end
  
  def create
    @credit_card = CreditCard.new(params[:credit_card])
    @credit_card.creditable_id = current_winery.id
    @credit_card.creditable_type = 'winery'
    
    if @credit_card.save
      flash[:notice] = "Successfully created credit card."
      redirect_to credit_cards_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @credit_card = current_winery.credit_cards.find(params[:id])
  end
  
  def update
    @credit_card = current_winery.credit_cards.find(params[:id])
    if @credit_card.update_attributes(params[:credit_card])
      flash[:notice] = "Successfully updated credit card."
      redirect_to credit_cards_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @credit_card = current_winery.credit_cards.find(params[:id])
    @credit_card.destroy
    flash[:notice] = "Successfully destroyed credit card."
    redirect_to credit_cards_url
  end

  def make_default
    result = Braintree::CreditCard.update(
      params[:token],
      :options => {
        :make_default => true
      }
    )
    redirect_to credit_cards_url
  end


end
