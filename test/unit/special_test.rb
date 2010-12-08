require 'test_helper'

class SpecialTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Special.new.valid?
  end
end
