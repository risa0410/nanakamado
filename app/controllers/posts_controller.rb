class PostsController < ApplicationController
  def new
    @user = current_user
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to post_path
  end

  def index
    @post = Post.all
  end

  def show
  end

  def destroy
  end


  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
