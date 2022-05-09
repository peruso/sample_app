class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  def new
    @user = User.new
  end
  
  def index
    # @users = User.all
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  
  end
  
  def create
    # @user = User.new(params[:user]) # 実装は終わっていないことに注意!
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      #保存の成功をここで扱う。
      redirect_to user_url(@user)
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
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
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
 