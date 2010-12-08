require 'test_helper'

class AwardsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Award.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Award.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Award.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to award_url(assigns(:award))
  end
  
  def test_edit
    get :edit, :id => Award.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Award.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Award.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Award.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Award.first
    assert_redirected_to award_url(assigns(:award))
  end
  
  def test_destroy
    award = Award.first
    delete :destroy, :id => award
    assert_redirected_to awards_url
    assert !Award.exists?(award.id)
  end
end
