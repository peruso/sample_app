
class SessionsController < ApplicationController

  def new

  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    # if user && user.authenticate(params[:session][:password])
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      #rails tutorial記載のコードではcreateは@userではなくuserで進めているため若干違いあり
      # もし同じようにuserとする場合にはリスト9.27,9.28を参考に修正する必要あり(:userは使えなくなるはず？)
      redirect_back_or @user
      
      
      
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end