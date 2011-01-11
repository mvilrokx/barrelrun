require 'test_helper'

class CreditCardTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert CreditCard.new.valid?
  end
end
