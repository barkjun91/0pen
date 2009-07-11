require 'test_helper'

class PostThreadsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:post_threads)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post_thread
    assert_difference('PostThread.count') do
      post :create, :post_thread => { }
    end

    assert_redirected_to post_thread_path(assigns(:post_thread))
  end

  def test_should_show_post_thread
    get :show, :id => post_threads(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => post_threads(:one).id
    assert_response :success
  end

  def test_should_update_post_thread
    put :update, :id => post_threads(:one).id, :post_thread => { }
    assert_redirected_to post_thread_path(assigns(:post_thread))
  end

  def test_should_destroy_post_thread
    assert_difference('PostThread.count', -1) do
      delete :destroy, :id => post_threads(:one).id
    end

    assert_redirected_to post_threads_path
  end
end
