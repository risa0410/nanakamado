class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :user_rooms
  has_many :chats

  # フォローされる側から中間テーブルへのアソシエーションの記述
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォローされる側からフォローしているユーザを取得する
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # フォローする側から中間テーブルへのアソシエーションの記述
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローする側からフォローされたユーザを取得する
  has_many :followings, through: :relationships, source: :followed

  # active_notificationsは自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  # passive_notificationsは相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { minimum: 1, maximum: 10 }
  validates :introduction, length: { maximum: 50 }
  has_one_attached :profile_image
  validate :profile_image_type


  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end


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


  private

  def profile_image_type
    if profile_image.attached?
      if !profile_image.blob.content_type.in?(%('profile_image/jpeg profile_image/png'))
        profile_image.purge # Rails6では、この1行は必要ない
        errors.add(:profile_image, 'はJPEGまたはPNG形式を選択してアップロードしてください')
      end
    end
  end
end
