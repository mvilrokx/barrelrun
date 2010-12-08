require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Rating.new.valid?
  end
end
