require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before do
    @user = User.create(name: 'Pety', email: 'aa@a.aa', password: '12345678')
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

end
