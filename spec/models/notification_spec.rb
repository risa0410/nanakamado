require 'rails_helper'

RSpec.describe 'Notificationモデルのテスト', type: :model do

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(UserRoom.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    context 'Roomモデルとの関係' do
      it '1:Nとなっている' do
        expect(UserRoom.reflect_on_association(:post_comment).macro).to eq :belongs_to
      end
    end
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(UserRoom.reflect_on_association(:visitor).macro).to eq :belongs_to
      end
    end
    context 'Roomモデルとの関係' do
      it '1:Nとなっている' do
        expect(UserRoom.reflect_on_association(:visited).macro).to eq :belongs_to
      end
    end
  end
end