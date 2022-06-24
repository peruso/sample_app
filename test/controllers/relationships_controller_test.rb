require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "create should require logged-in user" do
    # 下のブロック(postやdelete)を実施したのちrelationshipの数か変わっていないか確認する。
    # つまりrelationship数を追加、削除するアクションリクエストをしておいて
    # reationship_controllerのbefore_action :logged_in_userが効いているかセキュリティ確認しているのだろう。
    # 結果ログインしていないのでbefore_action :logged_in_userの効果からlogin_urlに飛ばされる

    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
end
