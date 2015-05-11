require 'rails_helper'

RSpec.describe Tag, type: :model do

  before do
    @tag = Tag.new
  end

  it 'should creates instance of comment' do
    expect(@tag).to be_kind_of(Tag)
  end

end
