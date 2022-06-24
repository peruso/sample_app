require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    # レスポンスが正しいテンプレートとレイアウトを描画していることを検証
    # users/show.html.erbを描画しているか
    assert_template 'users/show'
    # アクション実行の結果として描写されるHTMLの内容を検証する。
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    # 特定のHTMLタグが存在する→ strong id="following"
    assert_select 'strong#following'
    # 描写されたページに@user.following.countを文字列にしたものが含まれる
    assert_match @user.following.count.to_s, response.body
    # 特定のHTMLタグが存在する→ strong id="followers"
    assert_select 'strong#followers'
    # 描写されたページに@user.followers.countを文字列にしたものが含まれる
    assert_match @user.followers.count.to_s, response.body
    # 第二引数は第一引数の正規表現にマッチするか
    # response.bodyにはそのページの完全なHTMLが含まれている
    assert_match @user.microposts.count.to_s, response.body
    # <div role="navigation" aria-label="Pagination" class="pagination"><ul class="pagination"><li class="prev previous_page disabled"><a href="#">&#8592; Previous</a></li> <li class="active"><a href="/users/1?page=1">1</a></li> <li><a rel="next" href="/users/1?page=2">2</a></li> <li class="next next_page "><a rel="next" href="/users/1?page=2">Next &#8594;</a></li></ul></div>のところの検証？
    assert_select 'div.pagination', count: 1 #追加
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
