require 'test_helper'

class CreditCardsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => CreditCard.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    CreditCard.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    CreditCard.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to credit_card_url(assigns(:credit_card))
  end
  
  def test_edit
    get :edit, :id => CreditCard.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    CreditCard.any_instance.stubs(:valid?).returns(false)
    put :update, :id => CreditCard.first
    assert_template 'edit'
  end
  
  def test_update_valid
    CreditCard.any_instance.stubs(:valid?).returns(true)
    put :update, :id => CreditCard.first
    assert_redirected_to credit_card_url(assigns(:credit_card))
  end
  
  def test_destroy
    credit_card = CreditCard.first
    delete :destroy, :id => credit_card
    assert_redirected_to credit_cards_url
    assert !CreditCard.exists?(credit_card.id)
  end
end
