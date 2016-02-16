require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    sign_in_user

    before { get :show, id: @user.id }

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq @user
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
end
