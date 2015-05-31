class Blog.Base

  constructor: ->
    @body = $(document.body)
    @ajax = new Blog.Ajax()
    @findNodes()
    @addEvents()

    @initialize()

  initialize: ->

  findNodes: ->
    @nodes =
      $error: $()
      $errorContent: $()
      $success: $()
      $successContent: $()
      $warning: $()
      $warningContent: $()

  showError: (message) ->
    clearInterval(@errorTimeout)
    @nodes.$errorContent.html(message)
    @nodes.$error.fadeIn()
    @errorTimeout = setTimeout(@clearError.bind(@), 3000)

  showSuccess: (message) ->
    clearInterval(@successTimeout)
    @nodes.$successContent.html(message)
    @nodes.$success.fadeIn()
    @successTimeout = setTimeout(@clearSuccess.bind(@), 3000)

  showWarning: (message) ->
    clearInterval(@warningTimeout)
    @nodes.$warningContent.html(message)
    @nodes.$warning.fadeIn()
    @warningTimeout = setTimeout(@clearWarning.bind(@), 3000)

  clearError: ->
    @nodes.$error.fadeOut()

  clearSuccess: ->
    @nodes.$success.fadeOut()

  clearWarning: ->
    @nodes.$warning.fadeOut()

  relocate: (url) ->
    window.location.assign(url)

  openMainPage: ->
    @relocate('/')

  parseError: (response) ->
    json = response.responseJSON
    errorMessage = ''

    $.each(json.errors, (key, value)->
      $.each(value, (i, el) ->
        errorMessage += "#{key} #{el} <br />"
      )
    )

    @showError(errorMessage)

  addEvents: ->