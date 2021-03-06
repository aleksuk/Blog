require 'rails_helper'

RSpec.describe Article, type: :model do

  before do
    @article = Article.new(title: 'test', content: 'qwerty', article_tags: 'JavaScript, name')
  end

  after do
    Tag.destroy_all
  end

  it 'should creates instance of article' do
    expect(@article).to be_kind_of(Article)
  end

  it 'should return string of tags' do
    expect(@article.article_tags).to eq('JavaScript, name')
  end

  it 'should update article tags' do
    tags = 'Js, test'
    result_arr = Tag.where(name: tags.split(/\s*,\s*/))

    @article.article_tags = tags

    expect(@article.tags).to match_array(result_arr)
  end

  it 'should parse tags list into array' do
    expect(@article.send(:check_tags, 'JavaScript, name')).to match_array(['JavaScript', 'name'])
    expect(@article.send(:check_tags, nil)).to match_array([])
  end

end
