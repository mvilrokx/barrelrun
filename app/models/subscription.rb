class Subscription < ActiveRecord::Base
	belongs_to :winery
 
  attr_accessor :price, :balance, :billing_day_of_month, 
                :billing_period_end_date, :billing_period_start_date, 
                :first_billing_date, :never_expires, :next_billing_date, 
                :number_of_billing_cycles, :next_billing_period_amount, 
                :paid_through_date, :credit_card

  attr_accessible :winery_id, :status, :plan_id
  
  after_create :create_subscription_in_vault
  before_update :update_subscription_in_vault
  before_destroy :cancel_subscription_in_vault

  protected
  
    def after_find # Get vault info from Braintree
      braintree_subscription_data = Braintree::Subscription.find(id)
      self.price = braintree_subscription_data.price
      self.status = braintree_subscription_data.status
      self.balance = braintree_subscription_data.balance

      self.billing_day_of_month = braintree_subscription_data.billing_day_of_month
      self.billing_period_start_date = braintree_subscription_data.billing_period_start_date
      self.billing_period_end_date = braintree_subscription_data.billing_period_end_date
      self.first_billing_date = braintree_subscription_data.first_billing_date
      if braintree_subscription_data.never_expires?
        self.never_expires = "true"
      else
        self.never_expires = "false"
      end
      self.next_billing_date = braintree_subscription_data.next_billing_date
      self.number_of_billing_cycles = braintree_subscription_data.number_of_billing_cycles
      self.next_billing_period_amount = braintree_subscription_data.next_billing_period_amount
      self.paid_through_date = braintree_subscription_data.paid_through_date
      braintree_subscription_credit_card = Braintree::CreditCard.find(braintree_subscription_data.payment_method_token)
      self.credit_card = braintree_subscription_credit_card.masked_number
      
    end

    def update_subscription_in_vault
      result = Braintree::Subscription.update(
        id,
        :plan_id => plan_id
      )
    end

    def create_subscription_in_vault
      winery = Winery.find(winery_id)
      puts "winery.credit_cards[0].token = " + winery.credit_cards[0].token
      result = Braintree::Subscription.create(
        :id => id.to_s,
        :payment_method_token => winery.credit_cards[0].token,
        :plan_id => plan_id
      )
    end

    def cancel_subscription_in_vault
      result = Braintree::Subscription.cancel(id)
    end
  
end
