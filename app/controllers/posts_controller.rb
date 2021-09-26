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
      @user = current_user
      render :new
      # redirect_to new_post_path, alert: @post.errors.full_messages.join(", ")
    end
  end

  def index
    @user = current_user
    @post = Post.page(params[:page]).reverse_order
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @user = @post.user
  end

  def edit
    @post = Post.find(params[:id])
    @user = @post.user
    if @post.user != current_user
      redirect_to posts_path
    end
  end

  def update
    @post = Post.find(params[:id])
    @user = @post.user
    if @post.update(post_params)
      redirect_to post_path(@post)
      flash[:notice] = "You have updated book successfully."
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user)
    flash[:notice] = "You have created book successfully."
  end

  def hashtag
    @user = current_user
    @tag = Hashtag.find_by(hashname: params[:name])
    @posts = @tag.posts
  end

  def search
    @user = current_user
    @post = Post.search(params[:keyword])
    @keyword = params[:keyword]
    render :index
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :post_image)
  end

end
