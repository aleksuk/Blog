require 'rails_helper'

RSpec.describe ArticlesHelper, type: :helper do

  let(:article) { Article.new }

  before do
    @article = Article.create(title: 'Some title', content: 'Some content')
  end

  after do
    Article.all.each { |article| article.destroy }
  end

  it '#get_article_button_text' do
    expect(get_article_button_text(@article)).to eq(I18n.t('articles.updateArticle'))
    expect(get_article_button_text(article)).to eq(I18n.t('articles.createArticle'))
  end

end
