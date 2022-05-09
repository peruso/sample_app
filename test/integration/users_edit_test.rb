require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
    assert_select "div.alert", "The form contains 4 errors."
  end
  
  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
  
  
  test "successful edit with friendly forwarding" do
    
    get edit_user_path(@user)#log in前なので元のコードだとuser_urlにredirectされているはず。書き直しedit_user_urlにredirectするようにする
    
    assert_equal session[:forwarding_url], edit_user_url(@user) 
    #自分の編集ページかどうか。演習問題
    
    log_in_as(@user)
    
    # session[:forwarding_url]がnilの時true
    assert_redirected_to edit_user_url(@user)
    assert_nil session[:forwarding_url]
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end


# assert_redirected_to(options = {}, message=nil)

# 渡されたリダイレクトオプションが、最後に実行されたアクションで呼び出された
# リダイレクトのオプションと一致することを主張する。
# assert_redirected_to root_pathなどの名前付きルートを渡すことも、
# assert_redirected_to @articleなどのActive Recordオブジェクトを渡すことも
# 可能。