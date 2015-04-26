require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:user) do
    User.create(name: 'Name',
                email: 'email@ma.ms',
                password: '12345678',
                role_id: Role.find_by_name('admin').id)
  end

  after do
    Article.all.each { |article| article.destroy }
    User.all.each { |user| user.destroy }
  end

  before do
    Article.create(title: 'some title', content: 'some content')
    @article = Article.first
    @comment_body = 'comment body'
  end

  describe 'POST #create' do
    it 'creates comment' do
      post :create, article_id: @article.id, comment: { body: @comment_body }

      comment = @article.comments.first
      expect(assigns(:comment)).to eq(comment)
    end

    it 'redirects to article path' do
      post :create, article_id: @article.id, comment: { body: @comment_body }

      expect(response).to redirect_to(article_path(@article))
    end

    it 'renders comment template' do
      xhr :post, :create, article_id: @article.id, comment: { body: @comment_body }

      expect(response).to render_template(:_comment)
    end
  end

  describe 'DELETE #destroy' do
    it 'remove comment' do
      @article.comments.create(body: @comment_body)
      comment = @article.comments.first

      sign_in user

      xhr :delete, :destroy, article_id: @article.id, id: comment.id
      expect(@article.comments.all).to be_empty
    end
  end

  describe 'private methods' do
    it 'returns user id' do

      # @controller = described_class.new
      sign_in user
      expect(controller.instance_eval{ get_user_id }).to eq(user.id)
    end
  end

end
