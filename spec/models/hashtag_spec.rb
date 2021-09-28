require 'rails_helper'

RSpec.describe 'Hashtagモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { hashtag.valid? }

    let!(:hashtag) { build(:hashtag) }

    context 'hashnameカラム' do
      it '空欄でないこと' do
        hashtag.hashname = ''
        is_expected.to eq false
      end
      it '99文字以下であること: 99文字は〇' do
        hashtag.hashname = Faker::Lorem.characters(number: 99)
        is_expected.to eq true
      end
      it '99文字以下であること: 100文字は×' do
        hashtag.hashname = Faker::Lorem.characters(number: 100)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'PostHashtagRelationsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Hashtag.reflect_on_association(:post_hashtag_relations).macro).to eq :has_many
      end
    end
    context 'Postsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Hashtag.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
  end
end