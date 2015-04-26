require 'rails_helper'

RSpec.describe CommentsHelper, type: :helper do

  let(:user) { Class.new { attr_accessor :name }.new }

  it '#get_user_name' do
    name = 'Vasya'

    expect(get_user_name(nil)).to eq(I18n.t('users.unregisteredUser'))

    user.name = name
    expect(get_user_name(user)).to eq(name)
  end

end
