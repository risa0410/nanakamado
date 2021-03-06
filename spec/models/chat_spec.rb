require 'rails_helper'

RSpec.describe 'Chatモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { chat.valid? }

    let(:user) { create(:user) }
    let(:room) { create(:room)}
    let!(:chat) { build(:chat, user_id: user.id, room_id: room.id) }

    context 'messageカラム' do
      it '空欄でないこと' do
        chat.message = ''
        is_expected.to eq false
      end
      it '50文字以下であること: 50文字は〇' do
        chat.message = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end
      it '50文字以下であること: 51文字は×' do
        chat.message = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Chat.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Roomモデルとの関係' do
      it '1:Nとなっている' do
        expect(Chat.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
  end
end