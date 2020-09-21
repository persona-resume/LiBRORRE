require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '利用者情報編集' do
    context '利用者情報ページの表示' do
      it '利用者情報ページが表示される' do
        login_as_user
        get :show
        expect(response.status).to eq 200
      end

    end
  end

end
