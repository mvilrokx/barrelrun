require "rubygems"
require "braintree"

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "wj6wnxrgdvh5v5rx"
Braintree::Configuration.public_key = "cdcsdmnwsfdtmf2j"
Braintree::Configuration.private_key = "6k4b8m868p44dqpt"



result = Braintree::Customer.create(
  :first_name => "Charity",
  :last_name => "Smith",
  :credit_card => {
    :number => "5105105105105100",
    :expiration_date => "05/2010",
    :options => {
      :verify_card => true
    }
  }
)
if result.success?
  puts result.customer.id
  puts result.customer.credit_cards[0].token
else
  p result.errors
end


result = Braintree::Subscription.create(
  :payment_method_token => "jvwx",
  :plan_id => "GOLD_LEVEL"
)

if result.success?
  puts result.subscription.id
  puts result.subscription.transactions[0].id
end


result = Braintree::CreditCard.sale("jvwx", :amount => "10.00")

if result.success?
  puts "Transaction ID: #{result.transaction.id}"
  # status will be authorized or submitted_for_settlement
  puts "Transaction Status: #{result.transaction.status}"
else
  puts "Message: #{result.message}"
  if result.transaction.nil?
    # validation errors prevented transaction from being created
    p result.errors
  else
    puts "Transaction ID: #{result.transaction.id}"
    # status will be processor_declined, gateway_rejected, or failed
    puts "Transaction Status: #{result.transaction.status}"
  end
end

result = Braintree::Transaction.sale(
  :amount => "1000.00",
  :credit_card => {
    :number => "5105105105105100",
    :expiration_date => "05/12"
  }
)

if result.success?
  puts "Transaction ID: #{result.transaction.id}"
  # status will be authorized or submitted_for_settlement
  puts "Transaction Status: #{result.transaction.status}"
else
  puts "Message: #{result.message}"
  if result.transaction.nil?
    # validation errors prevented transaction from being created
    p result.errors
  else
    puts "Transaction ID: #{result.transaction.id}"
    # status will be processor_declined, gateway_rejected, or failed
    puts "Transaction Status: #{result.transaction.status}"
  end
end
