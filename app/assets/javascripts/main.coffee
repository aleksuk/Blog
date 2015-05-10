window.Blog =
  initialize: ->
    $.each(Blog.routing, (router, callback) ->
      callback() if document.querySelector(router)
    )