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

end
