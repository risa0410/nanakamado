require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let!(:post) { build(:post, user_id: user.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        post.title = ''
        is_expected.to eq false
      end
      it '1文字以上であること: 0文字は×' do
        post.title = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇' do
        post.title = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '10文字以下であること: 10文字は〇' do
        post.title = Faker::Lorem.characters(number: 10)
        is_expected.to eq true
      end
      it '10文字以下であること: 11文字は×' do
        post.title = Faker::Lorem.characters(number: 11)
        is_expected.to eq false
      end
    end

    context 'bodyカラム' do
      it '空欄でないこと' do
        post.body = ''
        is_expected.to eq false
      end
      it '1000文字以下であること: 1000文字は〇' do
        post.body = Faker::Lorem.characters(number: 1000)
        is_expected.to eq true
      end
      it '1000文字以下であること: 1001文字は×' do
        post.body = Faker::Lorem.characters(number: 1001)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    context 'PostCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
    context 'PostHashtagRelationモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:post_hashtag_relations).macro).to eq :has_many
      end
    end
    context 'Hashtagモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:hashtags).macro).to eq :has_many
      end
    end
  end
end