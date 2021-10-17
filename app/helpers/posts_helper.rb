module PostsHelper
  # リンク付きのハッシュタグが入ったキャプションが作成される
  def render_with_hashtags(body)
    body.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "hashtag/#{word.delete("#")}"}.html_safe
  end
end
