require 'rails_helper'

RSpec.describe Article, type: :model do

  before do
    @article = Article.new
  end

  it 'should creates instance of article' do
    expect(@article).to be_kind_of(Article)
  end

end
