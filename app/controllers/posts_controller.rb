class PostsController < ApplicationController

  def new
    @user = current_user
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
      flash[:notice] = "You have created book successfully."
    else
      render new_post_path
    end
  end

  def index
    @user = current_user
    @post = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @user = @post.user
    if @post.user != current_user
      redirect_to post_path
    end
  end

  def destroy
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :post_image)
  end

end
