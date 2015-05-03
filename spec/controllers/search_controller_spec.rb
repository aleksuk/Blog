require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  before(:all) do
    articles = [
        { title: 'yeoman', content: 'some content' },
        { title: 'yeoman 2', content: 'some content' },
        { title: 'test', content: 'some content' },
        { title: 'test 2', content: 'some content' }
    ]

    articles.each do |el|
      Article.create(el)
    end
  end

  after(:all) do
    Article.delete_all
  end

  let(:user) do
    User.create(name: 'Name',
                email: 'email@sd.sa',
                password: '12345678',
                role_id: Role.find_by_name('admin').id)
  end

  describe 'GET #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders index template' do
      get :index

      expect(response).to render_template(:index)
    end

    it 'finds articles by string' do
      get :index, query: 'yeoman'

      articles = Article.search { fulltext 'yeoman' }.results

      expect(assigns(:articles)).to match_array(articles)
    end
  end

  describe 'GET #find_article' do
    it 'returns 422 status code' do
      sign_in user

      get :find_article, query: ''

      expect(response).to have_http_status(422)
    end

    it 'redirects unregistered users' do
      get :find_article, query: ''

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns search results' do
      sign_in user

      get :find_article, query: 'yeoman'

      articles = Article.search { fulltext 'yeoman' }.results

      expect(assigns(:articles)).to match_array(articles)
    end
  end

  describe 'GET #find_user' do
    it 'returns 422 status code' do
      sign_in user

      get :find_user, query: ''

      expect(response).to have_http_status(422)
    end

    it 'redirects unregistered users' do
      get :find_user, query: ''

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns search results' do
      sign_in user

      get :find_user, query: 'Name'

      users = User.search { fulltext 'Name' }.results

      expect(assigns(:users)).to match_array(users)
    end
  end

end
