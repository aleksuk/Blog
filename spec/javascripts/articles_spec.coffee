#= spec_helper

describe 'Blog.Articles', ->
  beforeEach ->
    @articles = new Blog.Articles()

  it '#initialize init summernote plugin', (done) ->
    sinon.stub(@articles.nodes.$summernote, 'summernote')

    @articles.initialize()

    assert(@articles.nodes.$summernote.summernote.called, 'summernote wasn\'t initialized')
    done()

  it '#addEvents', (done) ->
    sinon.stub(@articles.addArticle, 'bind').returns(@articles.addArticle)
    sinon.stub(@articles.nodes.$articleForm, 'on')

    @articles.addEvents()

    assert(@articles.nodes.$articleForm.on.calledWith('submit', @articles.addArticle), 'events weren\'t added')
    done()

  it '#findNodes finds nodes', (done) ->
    delete @articles.nodes

    assert.isUndefined(@articles.nodes, 'nodes have still available')

    @articles.findNodes()

    assert.isObject(@articles.nodes, 'nodes weren\'t available')
    done()

  it '#updateContent updates text after clicking keys', (done) ->
    text = 'some text'
    sinon.stub(@articles.nodes.$articleContent, 'val')
    sinon.stub(@articles.nodes.$summernote, 'code').returns(text)

    @articles.updateContent()

    assert(@articles.nodes.$articleContent.val.calledWith(text), 'content wasn\'t updated')

    @articles.nodes.$articleContent.val.restore()
    @articles.nodes.$summernote.code.restore()
    done()

  context '#addArticle', ->
    beforeEach ->
      @event =
        target: 'target'

      @method=
        val: sinon.stub()

      @jqObj =
        val: sinon.stub()
        attr: sinon.stub().returns('/url')
        find: sinon.stub().returns(@method)

      sinon.stub(window, '$').returns(@jqObj)
      sinon.stub(@articles.ajax, 'update')
      sinon.stub(@articles.ajax, 'create')

    afterEach ->
      @articles.ajax.update.restore()
      @articles.ajax.create.restore()
      $.restore()

    it 'creates new article', (done) ->
      @articles.addArticle(@event)

      assert(@articles.ajax.create.called, 'article wasn\'t created')
      done()

    it 'updates article', (done) ->
      @method.val.returns('patch')
      @articles.addArticle(@event)

      assert(@articles.ajax.update.called, 'article wasn\'t updated')
      done()