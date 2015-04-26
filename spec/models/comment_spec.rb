require 'rails_helper'

RSpec.describe Comment, type: :model do

  before do
    @comment = Comment.new
  end

  it 'should creates instance of comment' do
    expect(@comment).to be_kind_of(Comment)
  end

end
