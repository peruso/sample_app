class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  def new
    @user = User.new
  end
  
  def index
    # @users = User.all
    # @users = User.paginate(page: params[:page])
    #有効でないユーザーは表示させないようにしている
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    # paginateで30個(デフォルトで決まっている）とってきている
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  
  end
  
  def create
    # @user = User.new(params[:user]) # 実装は終わっていないことに注意!
    @user = User.new(user_params)
    if @user.save
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      #保存の成功をここで扱う。
      # UserMailer.account_activation(@user).deliver_now
      #user.rbのdef send_avtivation_emailで送信指示
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      
      #変更前はユーザーのプロフィールページにリダイレクトしてた
      # redirect_to user_url(@user)
    else
      render 'new'
      # render 'users/new'これでも良いみたい。。
    end
  end
  
  def edit
    # @user = User.find(params[:id]) correct_userで改めて定義したので削除
  end
  
  def update
    # @user = User.find(params[:id]) correct_userで改めて定義したので削除
    if @user.update(user_params)
      # 更新に成功した場合を扱う。updateメソッドは属性のハッシュを受け取り、成功時には更新と保存を続けて同時に行います（保存に成功した場合はtrueを返します）。
      # ただし、検証に1つでも失敗すると、updateの呼び出しは失敗します。例えば6.3で実装すると、パスワードの保存を要求するようになり、検証で失敗するようになります。特定の属性のみを更新したい場合は、次のようにupdate_attributeを使います。このupdate_attributeには、検証を回避するといった効果もあります。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # beforeアクション

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
 