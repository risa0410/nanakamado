class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :user_rooms
  has_many :chats

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  # フォローされる側から中間テーブルへのアソシエーションの記述
  # フォローされる側からフォローしているユーザを取得する
  # フォローする側から中間テーブルへのアソシエーションの記述
  # フォローする側からフォローされたユーザを取得する
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  def following?(user)
    followings.include?(user)
  end

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  # active_notificationsは自分からの通知
  # passive_notificationsは相手からの通知
  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  has_one_attached :profile_image
  # validate :profile_image_type

  # private
  # def profile_image_type
  #   if !profile_image.blob.content_type.in?(%('profile_image/jpeg profile_image/png'))
  #     profile_image.purge # Rails6では、この1行は必要ない
  #     errors.add(:profile_image, 'はJPEGまたはPNG形式を選択してアップロードしてください')
  #   end
  # end
end
