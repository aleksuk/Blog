require 'rails_helper'

RSpec.describe Tagging, type: :model do

  before do
    @tagging = Tagging.new
  end

  it 'should creates instance of comment' do
    expect(@tagging).to be_kind_of(Tagging)
  end

end
