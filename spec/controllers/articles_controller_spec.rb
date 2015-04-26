require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  before(:all) do
    11.times { Article.create(title: 'Some title', content: 'Some Content') }
    @user = User.create(name: 'Name',
                        email: 'email@sdf.dd',
                        password: '12345678',
                        role_id: Role.find_by_name('admin').id)
  end

  after(:all) do
    Article.all.each { |article| article.destroy }
    User.all.each { |user| user.destroy }
  end

  describe 'GET #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      get :index

      expect(response).to render_template(:index)
    end

    it 'loads 10 posts' do
      get :index

      articles = Article.order(:created_at).page(1).per(10)
      expect(assigns(:articles)).to match_array(articles)
    end
  end

  describe 'GET #show' do
    it 'responds successfully with an HTTP 200 status code' do
      article = Article.first
      get :show, id: article.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the show template' do
      article = Article.first
      get :show, id: article.id

      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    it 'renders edit template' do
      article = Article.first
      sign_in @user

      get :edit, id: article.id

      expect(response).to render_template(:edit)
    end
  end

  describe 'GET #new' do
    it 'renders new template' do
      sign_in @user

      get :new

      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    it 'renders article template' do
      sign_in @user
      xhr :post, :create, article: { title: 'title', content: 'content' }

      expect(response).to be_success
    end

    it 'returns error end status code 422' do
      sign_in @user
      xhr :post, :create, article: { title: '', content: 'content' }

      expect(response).to have_http_status(422)
    end
  end

  describe 'DELETE #destroy' do
    it 'removes article' do
      article = Article.first
      sign_in @user

      delete :destroy, id: article.id

      expect(response).to redirect_to(articles_path)
    end
  end

end
