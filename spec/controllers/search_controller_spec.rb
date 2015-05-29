require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  let(:user) do
    User.create(name: 'Test',
                email: 'email@sd.sa',
                password: '12345678',
                role_id: Role.find_by_name('admin').id)
  end

  let(:sunspot_obj) do
    Class.new { attr_accessor :results }.new
  end

  before do
    sunspot_obj.results = nil
  end

  before(:all) do
    articles = [
        { title: 'yeoman', content: 'some content', article_tags: 'yeoman' },
        { title: 'yeoman 2', content: 'some content', article_tags: 'yeoman' },
        { title: 'test', content: 'some content', article_tags: 'test' },
        { title: 'test 2', content: 'some content', article_tags: 'test' }
    ]

    Article.create(articles)
  end

  after(:all) do
    Tagging.destroy_all
    Tag.destroy_all
    Article.destroy_all
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
      query = 'yeoman'
      sunspot_obj.results = Article.where(title: query)
      allow(Article).to receive(:search).and_return(sunspot_obj)

      get :index, query: query

      expect(assigns(:articles)).to match_array(sunspot_obj.results)
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
      query = 'yeoman'
      sunspot_obj.results = Article.where(title: 'yeoman')
      allow(Article).to receive(:search).and_return(sunspot_obj)

      sign_in user
      get :find_article, query: query

      expect(assigns(:articles)).to match_array(sunspot_obj.results)
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

    it 'returns search results', search:true do
      sign_in user

      sunspot_obj.results = User.where(name: 'Test')
      allow(User).to receive(:search).and_return(sunspot_obj)

      get :find_user, query: 'Test'

      expect(assigns(:users)).to match_array(sunspot_obj.results)
    end
  end

  describe '#valid_query?' do
    it 'returns true for valid query' do
      expect(controller.send(:valid_query?, 'adf')).to be_truthy
    end

    it 'returns false for invalid query' do
      expect(controller.send(:valid_query?, '')).to be_falsey
    end
  end

  describe '#create_response' do
    it 'calls render method with 422 status code and error message' do
      allow(controller).to receive(:render).with(status: 422, text: I18n.t('search.error'))

      controller.send(:create_response, [], 'admins/_articles')
    end

    it 'calls render method with passed partial' do
      partial_name = 'admins/_articles'
      allow(controller).to receive(:render).with(partial_name, layout: false)

      controller.send(:create_response, [1], partial_name)
    end
  end

  describe '#find_in' do
    it 'returns object with search result', search: true do
      query = 'yeoman'
      controller.params[:query] = query
      allow(Article).to receive(:search).and_return(sunspot_obj)

      expect(controller.send(:find_in, Article)).to eq(sunspot_obj)
    end
  end

end
