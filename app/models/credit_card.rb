class CreditCard < ActiveRecord::Base
	belongs_to :creditable, :polymorphic => true
  
  attr_accessor :card_number, :card_verification_value, :card_type
  
  validate :validate_card

  before_create :create_credit_card_in_vault
  before_update :update_credit_card_in_vault
  before_destroy :destroy_credit_card_in_vault

  protected

    def after_find # Get vault info from Braintree
      braintree_credit_card_data = Braintree::CreditCard.find(token)
      self.card_number = braintree_credit_card_data.masked_number
      self.card_type = braintree_credit_card_data.card_type
    end

    def validate_card
      winery = Winery.find(creditable_id)
      result = Braintree::CreditCard.create(
        :customer_id => winery.username,
        :number => card_number, #"5105105105105100"
        :cvv => card_verification_value,
        :expiration_month => expiration_date.month,
        :expiration_year => expiration_date.year,
        :options => {
            :verify_card => true
        }
      )
      
      unless result.success?
        result.errors.each do |error|
          errors.add_to_base error.message
        end
  #      verification = result.credit_card_verification
  #      if verification.try(:status) == "processor_declined"
  #        errors.add_to_base(verification.processor_response_text)
  #      elsif verification.try(:status) == "gateway_rejected"
  #        errors.add_to_base(verification.gateway_rejection_reason)
  #      end
      end
    end

    def create_credit_card_in_vault
      winery = Winery.find(creditable_id)
      result = Braintree::CreditCard.create(
        :customer_id => winery.username,
        :number => card_number, #"5105105105105100"
        :cvv => card_verification_value,
        :expiration_month => expiration_date.month,
        :expiration_year => expiration_date.year
      )
      self.token = result.credit_card.token
    end

    def update_credit_card_in_vault
      result = Braintree::CreditCard.update(
        token,
        :number => card_number,
        :cvv => card_verification_value,
        :expiration_month => expiration_date.month,
        :expiration_year => expiration_date.year
      )
    end

    def destroy_credit_card_in_vault
      result = Braintree::CreditCard.find(token).delete
    end

end
