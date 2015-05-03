require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before do
    @user = User.create(name: 'Pety', email: 'aa@a.aa', password: '12345678', role_id: 4)
    sign_in @user
  end

  after do
    User.all.each { |user| user.destroy }
  end

  describe 'GET #show' do
    it 'responds successfully with an HTTP 200 status code' do
      get :show

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders show template' do
      get :show

      expect(response).to render_template(:show)
    end
  end

  describe 'PATCH #update' do
    it 'updates user data' do
      sign_in @user
      new_name = @user.name + ' M'

      xhr :patch, :update, user: { id: @user.id, email: @user.email, name: new_name, role_id: @user.role.id }

      update_user = User.find(@user.id)
      expect(update_user.name).to eq(new_name)
    end

    it 'renders user template' do
      sign_in @user

      xhr :patch, :update, user: { id: @user.id, email: @user.email, name: @user.name, role_id: @user.role.id }

      expect(response).to render_template(partial: '_user')
    end

    it 'returns 422 status code' do
      sign_in @user

      xhr :patch, :update, user: { id: @user.id, email: '', name: '', role_id: @user.role.id }

      expect(response).to have_http_status(422)
    end
  end

end
