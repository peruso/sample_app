class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  
  end
  
  def create
    # @user = User.new(params[:user]) # 実装は終わっていないことに注意!
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      #保存の成功をここで扱う。
      redirect_to user_url(@user)
    else
      render 'new'
      # render 'users/new'これでも良いみたい。。
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
