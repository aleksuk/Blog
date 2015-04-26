class Blog.Articles extends Blog.Base

  actions:
    patch: 'update'
    post: 'create'

  target: '.article-form'

  initialize: ->
    super()
    $('.summernote').summernote(height: 300)

  addEvents: ->
    @nodes.$articleForm.on('submit', @addArticle.bind(@))

  findNodes: ->
    @nodes =
      $body: @body,
      $articleForm: @body.find('.article-form')
      $articleTitle: @body.find('.article-title')
      $articleContent: @body.find('.article-content')
      $error: @body.find('.alert-danger')
      $errorContent: @body.find('.article-error-content')

  addArticle: (e) ->
    $target = $(e.currentTarget)
    action = $target.find('[name=_method]').val() || 'post'

    @ajax[@actions[action]](
      url: $target.attr('action')
      data:
        article:
          title: @nodes.$articleTitle.val()
          content: @nodes.$articleContent.val()
      success: @relocate
      error: ((response) ->
        @showError response.responseJSON.join('<br />')
      ).bind(@)
    )