require 'rails_helper'

RSpec.describe Role, type: :model do

  it 'should always has 4 role' do
    expect(Role.all.count).to be(4)
  end

end
