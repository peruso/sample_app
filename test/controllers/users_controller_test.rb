require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  # test "should get show" do
  #   get show_path
  #   # 名前付きルートが使えるようにしたので下のように記載
  #   # get show_path
  #   assert_response :success
  # end

end
