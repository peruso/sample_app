
class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]    # （1）への対応
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    # user_paramsという書き方...ちょっといつもと違う。あ！下にメソッドを定義していた！
    #@userはbeforeの場所でセットしている
    if params[:user][:password].empty?                  # （3）への対応
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)                     # （4）への対応
      # 更新に成功した場合を扱う。updateメソッドは属性のハッシュを受け取り、成功時には更新と保存を続けて同時に行います（保存に成功した場合はtrueを返します）。
      # ただし、検証に1つでも失敗すると、updateの呼び出しは失敗します。例えば6.3で実装すると、パスワードの保存を要求するようになり、検証で失敗するようになります。特定の属性のみを更新したい場合は、次のようにupdate_attributeを使います。このupdate_attributeには、検証を回避するといった効果もあります。
      log_in @user
      # resetのcontorollerでcreateアクションでreset_digestは作成される
      # これを削除しておけば2時間以内に履歴からパスワード再設定フォームを表示されても更新はできない
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'                                     # （2）への対応
    end
  end
  
  private
    #上のupdateアクションで使用、strong Parameterというテクニック→許可する属性を設定している
    # これをメソッドにして使いやすくしている
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # beforeフィルタ

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
