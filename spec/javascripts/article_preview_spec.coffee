#= spec_helper

describe 'Blog.ArticlePreview', ->
  beforeEach ->
    @article = new Blog.ArticlePreview()

  it '#addEvents on nodes of module', (done) ->
    sinon.stub(@article.body, 'on')
    sinon.stub(@article.toggleArticlePreview, 'bind').returns(@article.toggleArticlePreview)
    @article.addEvents()

    assert(@article.body.on.calledWith('click', '.read-article', @article.toggleArticlePreview), 'events weren\'t added')

    @article.body.on.restore()
    done()

  context '#toggleArticlePreview', () ->
    beforeEach 'setup event object', ->
      @jqObj =
        hasClass: sinon.stub()

      @eventTarget =
        parent: sinon.stub().returns(@jqObj)

      @eventObj =
        preventDefault: sinon.stub()
        currentTarget: 'target'

      sinon.stub(window, '$').returns(@eventTarget)

    afterEach 'clear stubs', ->
      $.restore()

    it 'opens article', (done) ->
      @jqObj.hasClass.returns(true)
      sinon.stub(@article, 'showFullArticle')

      @article.toggleArticlePreview(@eventObj)

      assert(@article.showFullArticle.calledWith(@eventTarget, @jqObj), 'article wasn\'t showed')
      done()

    it 'hides article', (done) ->
      @jqObj.hasClass.returns(false)
      sinon.stub(@article, 'hideArticle')

      @article.toggleArticlePreview(@eventObj)

      assert(@article.hideArticle.calledWith(@eventTarget, @jqObj), 'article wasn\'t hidden')
      done()

  it '#showFullArticle opens article', (done) ->
    link =
      html: sinon.stub()

    articleContainer =
      removeClass: sinon.stub()

    @article.showFullArticle(link, articleContainer)

    assert(articleContainer.removeClass.calledWith('preview-article'), 'article wasn\'t showed')
    done()

  it '#hideArticle hides article', (done) ->
    link =
      html: sinon.stub()

    articleContainer =
      addClass: sinon.stub()

    @article.hideArticle(link, articleContainer)

    assert(articleContainer.addClass.calledWith('preview-article'), 'article wasn\'t hidden')
    done()