class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # マイクロポストの投稿が失敗すると、 Homeページは@feed_itemsインスタンス変数を期待しているため、現状では壊れてしまいます。解決方法は、Micropostsコントローラのcreateアクションへの送信が失敗した場合に備えて、必要なフィード変数をこのブランチで渡しておくこと
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
    # 上としたどちらでも良い
    # redirect_back(fallback_location: root_url)
  end
  
  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
