module CommentsHelper

  def get_user_name user
    user ? user.name : t('users.unregisteredUser')
  end

end
