require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do

  let(:current_user) do
    Class.new do
      attr_accessor :admin

      def admin?
        admin
      end

    end.new
  end

  it '#get_edit_form_additional_message' do
    expect(get_edit_form_additional_message(false)).to be_falsey
    expect(get_edit_form_additional_message(true)).to eq(I18n.t('authentication.help.info'))
  end

  it '#get_edit_form_button_text' do
    expect(get_edit_form_button_text(false)).to eq(I18n.t('authentication.registration'))
  end

  it '#is_admin?' do
    expect(is_admin?).to be_falsey

    current_user.admin = true
    expect(is_admin?).to be_truthy
  end

  it '#get_edit_form_title' do
    expect(get_edit_form_title(false)).to eq(I18n.t('authentication.registration'))
    expect(get_edit_form_title(true)).to eq(I18n.t('authentication.updateProfile'))
  end

  it '#has_errors?' do
    user = User.new
    expect(has_errors?(user)).to be_falsey

    user.errors.add(:name, 'name can\'t be empty')
    expect(has_errors?(user)).to be_truthy
  end

end
