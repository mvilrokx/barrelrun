require 'test_helper'

class SpecialsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Special.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Special.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Special.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to special_url(assigns(:special))
  end
  
  def test_edit
    get :edit, :id => Special.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Special.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Special.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Special.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Special.first
    assert_redirected_to special_url(assigns(:special))
  end
  
  def test_destroy
    special = Special.first
    delete :destroy, :id => special
    assert_redirected_to specials_url
    assert !Special.exists?(special.id)
  end
end
