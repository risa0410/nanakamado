class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
      # flash[:notice] = "You have updated user successfully."
    else
      render :edit
    end
  end

  def destroy
  end

  def favorite
    @user = User.find(params[:user_id])
    favorites = Favorite.where(user_id: current_user.id).pluck(:post_id)
    @favorite_list = Post.find(favorites)
    # ログイン中のユーザーのお気に入りのpost_idカラムを取得
    # postsテーブルから、お気に入り登録済みのレコードを取得
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

end
