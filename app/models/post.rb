class Post < ApplicationRecord

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
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
