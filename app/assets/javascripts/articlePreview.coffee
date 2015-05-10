class Blog.ArticlePreview extends Blog.Base

  addEvents: ->
    @body.on('click', '.read-article', @toggleArticlePreview.bind(@))

  toggleArticlePreview: (e) ->
    $target = $(e.currentTarget)
    $parent = $target.parent()

    if $parent.hasClass('preview-article')
      @showFullArticle($target, $parent)
    else
      @hideArticle($target, $parent)

    e.preventDefault()

  showFullArticle: ($link, $articleContainer) ->
    $link.html('Свернуть')
    $articleContainer.removeClass('preview-article')

  hideArticle: ($link, $articleContainer) ->
    $link.html('Читать полностью ...')
    $articleContainer.addClass('preview-article')