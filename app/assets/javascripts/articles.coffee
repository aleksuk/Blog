class Blog.Articles extends Blog.Base

  actions:
    patch: 'update'
    post: 'create'

  initialize: ->
#    super()
    @nodes.$summernote.summernote(height: 300, onkeyup: @updateContent.bind(@))

  addEvents: ->
    @nodes.$articleForm.on('submit', @addArticle.bind(@))

  findNodes: ->
    @nodes =
      $summernote: @body.find('.summernote')
      $body: @body,
      $articleForm: @body.find('.article-form')
      $articleTitle: @body.find('.article-title')
      $articleContent: @body.find('.article-content')
      $error: @body.find('.alert-danger')
      $errorContent: @body.find('.article-error-content')

  updateContent: ->
    @nodes.$articleContent.val(@nodes.$summernote.code())

  addArticle: (e) ->
    $target = $(e.target)
    action = $target.find('[name=_method]').val() || 'post'

    @ajax[@actions[action]](
      url: $target.attr('action')
      data:
        article:
          title: @nodes.$articleTitle.val()
          content: @nodes.$summernote.code()
      success: @relocate
      error: ((response) ->
        @showError response.responseJSON.join('<br />')
      ).bind(@)
    )

    return false