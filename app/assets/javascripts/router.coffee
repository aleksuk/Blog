Blog.routing =
  '#administration': ->
    admin = new Blog.Administration()

  '.articles-index': ->
    articles = new Blog.ArticlePreview()

  '.article-form': ->
    article = new Blog.Articles()

  '.login-form': ->
    authentication = new Blog.Authentication()

  '.add-comment': ->
    comments = new Blog.Comments()