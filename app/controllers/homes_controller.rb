class HomesController < ApplicationController

  def top
    @posts = Post.limit(4).order(created_at: :desc)
  end

  def about
  end

end
