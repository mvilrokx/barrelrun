require 'test_helper'

class RegistrationLevelsControllerTest < ActionController::TestCase
  def test_show
    get :show, :id => RegistrationLevel.first
    assert_template 'show'
  end
end
