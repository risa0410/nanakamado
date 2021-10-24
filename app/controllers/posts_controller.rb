class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
      flash[:notice] = "投稿が完了しました。"
    else
      render :new
    end
  end

  def index
    @posts = Post.page(params[:page]).reverse_order
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user != current_user
      redirect_to posts_path
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post)
      flash[:notice] = "投稿を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user)
    flash[:notice] = "投稿を削除しました。"
  end

  def hashtag
    @tag = Hashtag.find_by(hashname: params[:name])
    @posts = @tag.posts
    @posts = Kaminari.paginate_array(@posts).page(params[:page])
  end

  def search # 投稿のキーワード検索
    @post = Post.search(params[:keyword])
    @keyword = params[:keyword]
    @posts = Kaminari.paginate_array(@post).page(params[:page])
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :post_image)
  end

end
