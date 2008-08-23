require File.dirname(__FILE__) + '/../test_helper'

class VurlsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:vurls)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_vurl
    assert_difference('Vurl.count') do
      post :create, :vurl => { }
    end

    assert_redirected_to vurl_path(assigns(:vurl))
  end

  def test_should_show_vurl
    get :show, :id => vurls(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => vurls(:one).id
    assert_response :success
  end

  def test_should_update_vurl
    put :update, :id => vurls(:one).id, :vurl => { }
    assert_redirected_to vurl_path(assigns(:vurl))
  end

  def test_should_destroy_vurl
    assert_difference('Vurl.count', -1) do
      delete :destroy, :id => vurls(:one).id
    end

    assert_redirected_to vurls_path
  end
end
