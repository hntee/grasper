require 'test_helper'

class ArticleControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get download" do
    get :download
    assert_response :success
  end

end
