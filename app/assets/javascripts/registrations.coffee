class Blog.Registration extends Blog.Base

  actions:
    put: 'update'
    patch: 'update'
    post: 'create'

  successHandler:
    put: 'successUpdate'
    patch: 'successUpdate'
    post: 'openMainPage'

  findNodes: ->
    $userForm = @body.find('.edit-user-form')
    @nodes =
      $name: $userForm.find('.name')
      $email:$userForm.find('.email')
      $password: $userForm.find('.password')
      $passwordConfirmation: $userForm.find('.password-confirmation')
      $currentPassword: $userForm.find('.current-password')
      $userForm: $userForm
      $error: @body.find('.user-registration-error')
      $errorContent: @body.find('.user-registration-error-content')
      $success: @body.find('.user-registration-success')
      $successContent: @body.find('.user-registration-success-content')

  addEvents: ->
    @nodes.$userForm.on('submit', ((e) ->
      @ajax[@actions[@method]](
        url: @nodes.$userForm.attr('action')
        dataType: 'JSON'
        data:
          user:
            name: @nodes.$name.val()
            email: @nodes.$email.val()
            password: @nodes.$password.val()
            password_confirmation: @nodes.$passwordConfirmation.val()
            current_password: @nodes.$currentPassword.val()
        success: (->
          @[@successHandler[@method]]()
        ).bind(@)
        error: @parseError.bind(@)
      )

      e.preventDefault()
    ).bind(@))

  initialize: ->
    @nodes.$error.addClass('modal-message')
    @nodes.$success.addClass('modal-message')

    @getMethod()

  getMethod: ->
    @method = @nodes.$userForm.find('[name=_method]').val() || @nodes.$userForm.attr('method')

  parseError: (response) ->
    json = response.responseJSON
    errorMessage = ''

    $.each(json.errors, (key, value)->
      $.each(value, (i, el) ->
        errorMessage += "#{key} #{el} <br />"
      )
    )

    @showError(errorMessage)

  successUpdate: ->
    @showSuccess('Профиль успешно обновлен')
    @clearFields()

  clearFields: ->
    @nodes.$password.val('')
    @nodes.$passwordConfirmation.val('')
    @nodes.$currentPassword.val('')