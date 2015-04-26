require 'rails_helper'

RSpec.describe User, type: :model do

  before(:each) do
    @user = User.create(email: 'test@mail.com',
                         name: 'SomeName',
                         password: '12345678')
  end

  after(:each) do
    User.all.each { |user| user.destroy }
  end

  it 'should creates user with "registered" role by default' do
    expect(@user.role.name).to eq('registered')
  end

  it '#is_admin? check user permission' do
    expect(@user).not_to be_admin

    @user.role = Role.find_by_name('admin')
    @user.save

    expect(@user).to be_admin
  end

end
