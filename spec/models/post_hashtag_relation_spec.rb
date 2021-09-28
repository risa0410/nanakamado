require 'rails_helper'

RSpec.describe 'PostHashRelationモデルのテスト', type: :model do
    describe 'バリデーションのテスト' do
    subject { post_hashtag_relation.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'post_idカラム' do
      it '空欄でないこと' do
        post.id = ''
        is_expected.to eq false
      end
      it '一意性があること' do
        post.id = other_post.id
        is_expected.to eq false
      end
    end

    context 'hashtag_idカラム' do
      it '空欄でないこと' do
        hashtag.id = ''
        is_expected.to eq false
      end
      it '一意性があること' do
        hashtag.id = other_hashtag.id
        is_expected.to eq false
      end
    end

    context 'hashtag_idカラム' do
      it '50文字以下であること: 50文字は〇' do
        user.introduction = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end
      it '50文字以下であること: 51文字は×' do
        user.introduction = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(PostHashRelation.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    context 'Roomモデルとの関係' do
      it '1:Nとなっている' do
        expect(PostHashRelation.reflect_on_association(:hashtag).macro).to eq :belongs_to
      end
    end
  end
end