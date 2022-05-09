require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "layout links when not logged in" do
    #root_pathへgetのリクエスト
    get root_path
    #static_pages/homeが描画される
    assert_template 'static_pages/home'
    # 特定のHTMLタグが存在する　タグの種類(a href), リンク先のパス, タグの数
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    #下は演習で追加
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign up")
    
  end
  
  def setup
    @user = users(:michael)
  end
  
  test "layout links when logged in" do
    #loginする
    log_in_as(@user)
    #root_pathへgetのリクエスト
    get root_path
    #static_pages/homeが描画される
    assert_template 'static_pages/home'
    # 特定のHTMLタグが存在する　タグの種類(a href), リンク先のパス, タグの数
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    # assert_select "a[href=?]", user_path(@user.id) これでもokそう
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path

  end
  
  
  # test "the truth" do
  #   assert true
  # end
end
