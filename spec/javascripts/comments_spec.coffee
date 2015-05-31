#= spec_helper

describe 'Blog.Comments', ->
  beforeEach ->
    @comments = new Blog.Comments()

  it '#findNodes finds nodes', (done) ->
    delete @comments.nodes

    assert.isUndefined(@comments.nodes, 'nodes are available')

    @comments.findNodes()

    assert.isObject(@comments.nodes, 'nodes are not object')
    done()

  it '#addEvents', (done) ->
    sinon.stub(@comments.nodes.$commentForm, 'on')
    sinon.stub(@comments.nodes.$comments, 'on')
    sinon.stub(@comments.submitHandler, 'bind').returns(@comments.submitHandler)
    sinon.stub(@comments.deleteComment, 'bind').returns(@comments.deleteComment)

    @comments.addEvents()

    assert(@comments.nodes.$commentForm.on.calledWith('submit', @comments.submitHandler),
      'Invalid event or handler for $commentForm'
    )

    assert(
      @comments.nodes.$comments.on.calledWith('click', '.delete-comment', @comments.deleteComment),
      'Invalid event or handler for $comments'
    )

    @comments.nodes.$commentForm.on.restore()
    @comments.nodes.$comments.on.restore()
    @comments.submitHandler.bind.restore()
    @comments.deleteComment.bind.restore()
    done()

  it '#initialize', (done) ->
    sinon.stub(@comments.nodes.$error, 'addClass');

    @comments.initialize()

    assert(@comments.nodes.$error.addClass.calledWith('modal-message'), 'js class wasn\'t added')

    @comments.nodes.$error.addClass.restore()
    done()

  context '#submitHandler', ->
    beforeEach ->
      @event =
        preventDefault: sinon.stub()

      sinon.stub(@comments.nodes.$commentBody, 'val').returns('')
      sinon.stub(@comments, 'validate').returns(false)
      sinon.stub(@comments, 'createComment')

    afterEach ->
      @comments.nodes.$commentBody.val.restore()

    it 'creates comment', (done) ->
      text = 'some text'
      @comments.nodes.$commentBody.val.returns(text)
      @comments.validate.returns(true)

      @comments.submitHandler(@event)

      assert(@comments.createComment.calledWith(commentContent: text), 'comment wasn\'t create')
      done()

    it 'doesn\'t create comment if validation failed', (done) ->
      @comments.submitHandler(@event)

      assert.notOk(@comments.createComment.called, 'comment was created')
      done()

  it '#createComemnt creates comment', (done) ->
    sinon.stub(@comments.ajax, 'create')

    @comments.createComment({})

    assert(@comments.ajax.create.called, 'comment wasn\'t create')
    done()

  it '#addComment', (done) ->
    sinon.stub(@comments.nodes.$comments, 'prepend')
    sinon.stub(@comments, 'clearCommentField')
    commentObj = {}

    @comments.addComment(commentObj)

    assert(@comments.nodes.$comments.prepend.calledWith(commentObj), 'comment wasn\'t added')
    done()

  it '#clearCommentField clears comment field', (done) ->
    sinon.stub(@comments.nodes.$commentBody, 'val')

    @comments.clearCommentField()

    assert(@comments.nodes.$commentBody.val.calledWith(''), 'comment body wasn\'t cleared')

    @comments.nodes.$commentBody.val.restore()
    done()

  context '#validate', ->
    beforeEach ->
      sinon.stub(@comments, 'showError')
      sinon.stub(@comments, 'clearError')

    it 'returns false if validation failed', (done) ->
      text = ''

      assert.isFalse(@comments.validate(text), 'invalid validation result')
      done()

    it 'returns true if validation passed', (done) ->
      text = '123'

      assert.isTrue(@comments.validate(text), 'invalid validation result')
      done()

  it '#deleteComment destroys comment', (done) ->
    event =
      target: {}

    sinon.stub(@comments.ajax, 'destroy')

    @comments.deleteComment(event)

    assert(@comments.ajax.destroy.called, 'comment wasn\'t destroy');

    @comments.ajax.destroy.restore()
    done()