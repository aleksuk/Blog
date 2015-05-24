class Blog.Articles extends Blog.Base

  actions:
    patch: 'update'
    post: 'create'

  initialize: ->
    @nodes.$summernote.summernote(
      height: 300
      onkeyup: @updateContent.bind(@)
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'italic', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['fontsize', ['fontsize']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['height', ['height']],
        ['table', ['table']],
        ['insert', ['link', 'picture', 'hr']],
        ['view', ['fullscreen', 'codeview']],
        ['help', ['help']]
      ]

      @nodes.$error.addClass('modal-message')
    )

  addEvents: ->
    @nodes.$articleForm.on('submit', @addArticle.bind(@))

  findNodes: ->
    @nodes =
      $summernote: @body.find('.summernote')
      $body: @body,
      $articleForm: @body.find('.article-form')
      $articleTitle: @body.find('.article-title')
      $articleTags: @body.find('.article-tags')
      $articleContent: @body.find('.article-content')
      $error: @body.find('.article-error')
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
          article_tags: @nodes.$articleTags.val()
      success: @relocate
      error: ((response) ->
        @showError response.responseJSON.join('<br />')
      ).bind(@)
    )

    return false