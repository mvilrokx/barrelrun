require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Award.new.valid?
  end
end
