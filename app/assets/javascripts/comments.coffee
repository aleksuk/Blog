class Blog.Comments extends Blog.Base

  findNodes: ->
    @nodes =
      $body: @body
      $error: @body.find('.comment-error')
      $errorContent: @body.find('.comment-error-content')
      $commentForm: @body.find('.add-comment')
      $comments: @body.find('.comments')
      $commentBody: @body.find('.comment-body')
      $submitButton: @body.find('.add-comment [type=submit]')

  addEvents: ->
    @nodes.$commentForm.on('submit', @submitHandler.bind(@))
    @nodes.$comments.on('click', '.delete-comment', @deleteComment.bind(@))

  initialize: ->
    @nodes.$error.addClass('modal-message')

  submitHandler: (event) ->
    event.preventDefault()
    content = @nodes.$commentBody.val()

    return unless @validate(content)

    @createComment(commentContent: content)
    return

  createComment: (params) ->
    @ajax.create(
      data:
        comment:
          body: params.commentContent
      url: @nodes.$commentForm.attr('action')
      success: ((comment) ->
        @addComment comment
      ).bind(@)
    )

  addComment: (comment) ->
    @nodes.$comments.prepend(comment)
    @clearCommentField()

  clearCommentField: ->
    @nodes.$commentBody.val('')

  validate: (params) ->
    if params && params.length >= 2
      @clearError()
      true
    else
      @showError('Длина комментария не может быть менее 2 символов')
      false

  deleteComment: (event) ->
    $target = $(event.target)

    @ajax.destroy(
      url: $target.attr('href')
      success: ->
        $target
          .parents('.comment')
          .remove()
      error: (->
        @showError('Ошибка! Невозможно удалить комментарий!')
      ).bind(@)
    )

    return false