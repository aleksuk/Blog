class Blog.ResetPassword extends Blog.Base

  findNodes: ->
    $resetForm = @body.find('.reset-password-form')

    @nodes =
      $body: @body
      $resetForm: $resetForm
      $passwordField: $resetForm.find('.password')
      $passwordConfirmation: $resetForm.find('.password-confirmation')
      $token: $resetForm.find('.token')
      $error: @body.find('.reset-password-error')
      $errorContent: @body.find('.reset-password-error-content')

  initialize: ->
    @nodes.$error.addClass('modal-message')

  addEvents: ->
    @nodes.$resetForm.on('submit', @resetPassword.bind(@))

  resetPassword: (e) ->
    @ajax.update(
      url: '/users/password'
      dataType: 'JSON'
      data:
        user:
          password: @nodes.$passwordField.val()
          password_confirmation: @nodes.$passwordConfirmation.val()
          reset_password_token: @nodes.$token.val()
      success: @relocate.bind(@, '/')
      error: ((response) ->
        @parseError(response)
      ).bind(@)
    )

    e.preventDefault()