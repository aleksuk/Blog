require 'rails_helper'

RSpec.describe AdminsController, type: :controller do

  let(:user) do
    User.create(name: 'Name',
                email: 'email@sd.sa',
                password: '12345678',
                role_id: Role.find_by_name('admin').id)
  end

  after do
    User.all.each { |user| user.destroy }
  end

  describe 'GET #show' do
    it 'redirects users without permission on home page' do
      get :show

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'responds successfully with an HTTP 200 status code' do
      sign_in user

      get :show

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders show template' do
      sign_in user

      get :show

      expect(response).to render_template(:show)
    end
  end

  describe 'GET #change_users' do
    it 'renders users template' do
      sign_in user

      get :change_users, page: 1

      expect(response).to render_template(partial: '_users')
    end
  end

  describe 'GET #change_articles' do
    it 'renders articles template' do
      sign_in user

      get :change_articles, page: 1

      expect(response).to render_template(partial: '_articles')
    end
  end

  describe 'PATCH #edit_user' do
    it 'updates user data' do
      sign_in user
      new_name = user.name + ' M'

      xhr :patch, :edit_user, user: { id: user.id, email: user.email, name: new_name, role_id: user.role.id }

      update_user = User.find(user.id)
      expect(update_user.name).to eq(new_name)
    end

    it 'renders user template' do
      sign_in user

      xhr :patch, :edit_user, user: { id: user.id, email: user.email, name: user.name, role_id: user.role.id }

      expect(response).to render_template(partial: '_user')
    end

    it 'returns 422 status code' do
      sign_in user

      xhr :patch, :edit_user, user: { id: user.id, email: '', name: '', role_id: user.role.id }

      expect(response).to have_http_status(422)
    end
  end

end
