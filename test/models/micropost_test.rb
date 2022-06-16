require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    #下が慣習的に正しい書き方
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end
# validはこちらで作成したmethodではない
  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
    # micropost.rbでvalidationとしてuser_id:presenseをtrueとしているため
    # 上のuser_idをnilとするとvalid?で無効(false)と判断され、assert_notで期待していた結果となる
  end
  
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end
  
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
    # validationをmicropost.rbに入れねば、141文字でも@micropost.valid?で有効(true)となる
    # 結果、assert_notでfalse or nilの結果を期待していてもtrueで返すのでtest結果がerrorとなってしまう 
  
  end
  
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
  
  
end
