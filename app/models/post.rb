class Post < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :post_hashtag_relations, dependent: :destroy
  has_many :hashtags, through: :post_hashtag_relations
  validates :title, presence: true, length: { minimum: 1, maximum: 10 }
  validates :body, presence: true, length: { maximum: 1000 }
  has_one_attached :post_image
  validate :post_image_type


  # ハッシュタグ
  after_create do
    post = Post.find_by(id: self.id)
    hashtags  = self.body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    post.hashtags = []
    hashtags.uniq.map do |hashtag|
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


  # いいね
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end


  # 検索機能
  def self.search(keyword)
    where(["title like? OR body like?", "%#{keyword}%", "%#{keyword}%"])
  end


  # 通知機能 いいね
  def create_notification_favorite!(current_user)
    # 既に「いいね」されているかを検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    # いいねがされていなかったら、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      # 自分で自分の投稿にいいねした場合は、通知済みにする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end


  # 通知機能 コメント
  def create_notification_comment!(current_user, post_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, post_comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントをしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, post_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, post_comment_id, visited_id)
    # １つの投稿に複数回の通知ができる状態
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分で自分の投稿にコメントした場合は、通知済みにする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end


  private

  def post_image_type
    if !post_image.attached?
      errors.add(:base, '画像が登録されていません')
    elsif !post_image.blob.content_type.in?(%('post_image/jpeg post_image/png'))
      post_image.purge # Rails6では、この1行は必要ない
      errors.add(:base, 'JPEGまたはPNG形式の画像を登録してください')
    end
  end

end
