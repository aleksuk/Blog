class Blog.Ajax

  instance = null

  constructor: ->
    unless instance
      instance = this

    return instance

  destroy: (params) ->
    $.ajax(
      url: params.url
      method: 'DELETE'
      success: params.success
      error: params.error
      dataType: params.dataType
    )

  update: (params) ->
    $.ajax(
      url: params.url
      data: params.data
      method: 'PATCH'
      success: params.success
      error: params.error
      dataType: params.dataType
    )

  get: (params) ->
    $.ajax(
      url: params.url
      data: params.data
      success: params.success
      error: params.error
      dataType: params.dataType
    )

  create: (params) ->
    $.ajax(
      url: params.url
      method: 'POST'
      data: params.data
      success: params.success
      error: params.error
      dataType: params.dataType
    )