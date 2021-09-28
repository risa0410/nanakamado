require 'rails_helper'

RSpec.describe 'PostHashRelationモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post_hashtag_relation.valid? }

    let(:post) { create(:post) }
    let(:hashtag) { create(:hashtag) }
    let!(:post_hashtag_relation) { build(:post_hashtag_relation, post_id: post.id, hashtag_id: hashtag.id) }


    context 'post_idカラム' do
      it '空欄でないこと' do
        post.id = ''
        is_expected.to eq false
      end
    end

    context 'hashtag_idカラム' do
      it '空欄でないこと' do
        hashtag.id = ''
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(PostHashtagRelation.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    context 'Hashtagモデルとの関係' do
      it '1:Nとなっている' do
        expect(PostHashtagRelation.reflect_on_association(:hashtag).macro).to eq :belongs_to
      end
    end
  end
end