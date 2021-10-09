require 'rails_helper'

RSpec.describe "Relationships", type: :system do
before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
  end

  describe '#create,#destroy' do
    it 'ユーザーをフォロー、フォロー解除できる' do
        # @user1としてログイン
        sign_in(@user1)

        # @user1としてユーザー一覧ページへ遷移する
        visit users_path(@user1)

        # @user2をフォローする
        find('#nofollow').click
        expect(page).to have_selector '#yesfollow'
        expect(@user2.followed.count).to eq(1)
        expect(@user1.follower.count).to eq(1)
        
        # @user2をフォロー解除する
        find('#yesfollow').click
        expect(page).to have_selector '#nofollow'
        expect(@user2.followed.count).to eq(0)
        expect(@user1.follower.count).to eq(0)
    end
  end
end