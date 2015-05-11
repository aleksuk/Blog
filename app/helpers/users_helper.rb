module UsersHelper

  def get_edit_form_additional_message is_edit
    t('authentication.help.info') if is_edit
  end

  def get_edit_form_button_text is_edit
    is_edit ? t('authentication.updateProfile') : t('authentication.registration')
  end

  def is_admin?
    current_user && current_user.admin?
  end

  def get_edit_form_title is_edit
    (is_edit) ? t('authentication.updateProfile') : t('authentication.registration')
  end

  def show_error_messages resource
    resource.errors.full_messages.map { |msg| msg }.join('<br />')
  end

  def has_errors? resource
    resource.errors.size > 0
  end

end
