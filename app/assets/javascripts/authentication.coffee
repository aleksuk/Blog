class Blog.Authentication extends Blog.Base

  findNodes: ->
    $loginForm = @body.find('.login-form')

    @nodes =
      $body: @body
      $loginForm: @body.find('.login-form')
      $emailField: $loginForm.find('.email')
      $passwordField: $loginForm.find('.password')
      $rememberMe: $loginForm.find('.remember-me')
      $error: @body.find('.login-error')
      $errorContent: @body.find('.login-error-content')

  addEvents: ->
    @nodes.$loginForm.on('submit', @login.bind(@))
    @nodes.$emailField.on('focus', @removeFieldsError.bind(@))
    @nodes.$passwordField.on('focus', @removeFieldsError.bind(@))

  login: (e) ->
    @ajax.create(
      url: '/users/sign_in'
      data:
        user:
          email: @nodes.$emailField.val()
          password: @nodes.$passwordField.val()
          rememberMe: @nodes.$rememberMe.val()
      success: (->
        @relocate('/')
      ).bind(@)
      error: ((response) ->
        @showError response.responseText
      ).bind(@)
    )

    e.preventDefault()

  showError: (message) ->
    clearInterval(@errorTimeout)

    @nodes.$emailField.parents('.control-group').addClass('has-error')
    @nodes.$passwordField.parents('.control-group').addClass('has-error')
    @nodes.$passwordField.val('')
    @nodes.$errorContent.html(message)
    @nodes.$error.fadeIn()

    @isActiveError = true

    @errorTimeout = setTimeout(@clearError.bind(@), 3000)

  removeFieldsError: ->
    if @isActiveError
      @nodes.$emailField.parents('.control-group').removeClass('has-error')
      @nodes.$passwordField.parents('.control-group').removeClass('has-error')
      @isActiveError = false