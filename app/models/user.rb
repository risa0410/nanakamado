class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_one_attached :profile_image
  validate :profile_image_type

  private
  def profile_image_type
    if !profile_image.blob.content_type.in?(%('profile_image/jpeg profile_image/png'))
      profile_image.purge # Rails6では、この1行は必要ない
      errors.add(:profile_image, 'はJPEGまたはPNG形式を選択してアップロードしてください')
    end
  end
end
