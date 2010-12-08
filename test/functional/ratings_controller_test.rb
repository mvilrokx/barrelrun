require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Rating.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Rating.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Rating.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to rating_url(assigns(:rating))
  end
  
  def test_edit
    get :edit, :id => Rating.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Rating.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Rating.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Rating.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Rating.first
    assert_redirected_to rating_url(assigns(:rating))
  end
  
  def test_destroy
    rating = Rating.first
    delete :destroy, :id => rating
    assert_redirected_to ratings_url
    assert !Rating.exists?(rating.id)
  end
end
