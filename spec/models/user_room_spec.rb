require 'rails_helper'

RSpec.describe 'UserRoomモデルのテスト', type: :model do

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(UserRoom.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Roomモデルとの関係' do
      it '1:Nとなっている' do
        expect(UserRoom.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
  end
end