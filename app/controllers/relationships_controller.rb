class RelationshipsController < ApplicationController

  # フォロー機能を作成・保存・削除する
  def create
    @user = User.find(params[:user_id])
    current_user.follow(params[:user_id])
    @user.create_notification_follow!(current_user)
    # redirect_to request.referer
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(params[:user_id])
    # redirect_to request.referer
  end


  # フォロー・フォロワー一覧を表示する
  def followings # フォローしているユーザー
    @user = User.find(params[:user_id])
    @users = @user.followings
  end

  def followers # フォローされているユーザー
    @user = User.find(params[:user_id])
    @users = @user.followers
  end

end
