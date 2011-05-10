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
  
  LEVELS = ["Free", "Bronze", "Silver", "Gold"]
  FEATURES = ["Setup Fee", 
              "Business data", 
              "Push Wine information", 
              "Push Wine Specials", 
              "Push Wine Events",
              "Display videos", 
              "Upload pictures", 
              "Publish wine awards", 
              "Complete winery detail page", 
              "Barrel of a Deal Transaction Fee", 
              "Featured Winery - All Regions", 
              "Featured Winery - Localized", 
              "Real-Time Stats - coming soon",
              "Subscription Price Guaranteed", 
              "Integration with mobile app"]
  
  LEVEL_FEATURES= Hash.new(true)
  
  LEVEL_FEATURES[[ LEVELS[0], FEATURES[0] ]] = "Waived"
  LEVEL_FEATURES[[ LEVELS[1], FEATURES[0] ]] = "Waived"
  LEVEL_FEATURES[[ LEVELS[2], FEATURES[0] ]] = "Waived"
  LEVEL_FEATURES[[ LEVELS[3], FEATURES[0] ]] = "Waived"

  LEVEL_FEATURES[[LEVELS[0], FEATURES[5] ]] = false

  LEVEL_FEATURES[[LEVELS[0], FEATURES[6] ]] = false
  LEVEL_FEATURES[[LEVELS[1], FEATURES[6] ]] = "15Mb"
  LEVEL_FEATURES[[LEVELS[2], FEATURES[6] ]] = "50Mb"
  LEVEL_FEATURES[[LEVELS[3], FEATURES[6] ]] = "Unlimited"
  
  LEVEL_FEATURES[[LEVELS[0], FEATURES[7] ]] = false
  
  LEVEL_FEATURES[[LEVELS[0], FEATURES[8] ]] = false
  
  LEVEL_FEATURES[[LEVELS[0], FEATURES[9] ]] = "30%"
  LEVEL_FEATURES[[LEVELS[1], FEATURES[9] ]] = "20%"
  LEVEL_FEATURES[[LEVELS[2], FEATURES[9] ]] = "12%"
  LEVEL_FEATURES[[LEVELS[3], FEATURES[9] ]] = "7%"

  LEVEL_FEATURES[[LEVELS[0], FEATURES[10] ]] = false
  LEVEL_FEATURES[[LEVELS[1], FEATURES[10] ]] = false
  LEVEL_FEATURES[[LEVELS[2], FEATURES[10] ]] = false

  LEVEL_FEATURES[[LEVELS[0], FEATURES[11] ]] = false
  
  LEVEL_FEATURES[[LEVELS[0], FEATURES[12] ]] = false
  
  LEVEL_FEATURES[[LEVELS[0], FEATURES[13] ]] = false
  LEVEL_FEATURES[[LEVELS[1], FEATURES[13] ]] = false
  
  LEVEL_FEATURES[[LEVELS[0], FEATURES[14] ]] = false
  
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
        self.never_expires = "True"
      else
        self.never_expires = "False"
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
        :payment_method_token => credit_card,
        :plan_id => plan_id
      )
      unless result.success?
        result.errors.each do |error|
          errors.add_to_base error.message
        end
        return false # don't update record
      end
    end

    def create_subscription_in_vault
#      winery = Winery.find(winery_id)
#      puts "winery.credit_cards[0].token = " + winery.credit_cards[0].token
      result = Braintree::Subscription.create(
        :id => id.to_s,
        :payment_method_token => credit_card, #winery.credit_cards[0].token,
        :plan_id => plan_id
      )
      unless result.success?
        result.errors.each do |error|
          errors.add_to_base error.message
        end
        return false # don't create a new record
      end

    end

    def cancel_subscription_in_vault
      result = Braintree::Subscription.cancel(id)
    end
  
end
