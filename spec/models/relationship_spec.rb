require 'rails_helper'

RSpec.describe 'Relationshipモデルのテスト', type: :model do
  let(:relationship) { FactoryBot.create(:relationship) }
  describe '#create' do
    context "保存できる場合" do
      it "全てのパラメーターが揃っていれば保存できる" do
        expect(relationship).to be_valid
      end
    end

    context "保存できない場合" do
      it "follower_idがnilの場合は保存できない" do
        relationship.follower_id = nil
        relationship.valid?
        expect(relationship.errors[:follower]).to include("を入力してください")
      end

      it "followed_idがnilの場合は保存できない" do
        relationship.followed_id = nil
        relationship.valid?
        expect(relationship.errors[:followed]).to include("を入力してください")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Followerモデルとの関係' do
      it 'N:1となっている' do
        expect(Relationship.reflect_on_association(:follower).macro).to eq :belongs_to
      end
    end
    context 'Followedモデルとの関係' do
      it '1:Nとなっている' do
        expect(Relationship.reflect_on_association(:followed).macro).to eq :belongs_to
      end
    end
  end
end