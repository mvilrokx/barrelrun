require 'test_helper'

class RegistrationLevelTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert RegistrationLevel.new.valid?
  end
end
