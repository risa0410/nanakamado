class Post < ApplicationRecord

  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
  def self.search(keyword)
    where(["title like? OR body like?", "%#{keyword}%", "%#{keyword}%"])
  end

  def create_notification_favorite!(current_user) # いいねがされているかどうか
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
  def create_notification_comment!(current_user, post_comment_id) # コメントがされているかどうか
    temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, post_comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, post_comment_id, user_id) if temp_ids.blank?
  end
  def save_notification_comment!(current_user, post_comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end


  has_many :post_hashtag_relations, dependent: :destroy
  has_many :hashtags, through: :post_hashtag_relations

  after_create do
    post = Post.find_by(id: self.id)
    hashtags  = self.body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    post.hashtags = []
    hashtags.uniq.map do |hashtag|
      #ハッシュタグは先頭の'#'を外した上で保存
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.hashtags << tag
    end
  end
  before_update do
    post = Post.find_by(id: self.id)
    post.hashtags.clear
    hashtags = self.body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.hashtags << tag
    end
  end

  has_one_attached :post_image
  validate :post_image_type

  private
  def post_image_type
    if !post_image.blob.content_type.in?(%('post_image/jpeg post_image/png'))
      post_image.purge # Rails6では、この1行は必要ない
      errors.add(:post_image, 'はJPEGまたはPNG形式を選択してアップロードしてください')
    end
  end

end
