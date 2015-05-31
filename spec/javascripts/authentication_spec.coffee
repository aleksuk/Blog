#= spec_helper

describe 'Blog.Authentication', ->
  beforeEach ->
    @auth = new Blog.Authentication()

  it '#findNodes finds nodes', (done) ->
    delete @auth.nodes

    assert.isUndefined(@auth.nodes, 'nodes are available')

    @auth.findNodes()

    assert.isObject(@auth.nodes, 'nodes are not object')
    done()

  it '#addEvents', (done) ->
    sinon.stub(@auth.nodes.$loginForm, 'on')
    sinon.stub(@auth.nodes.$emailField, 'on')
    sinon.stub(@auth.nodes.$passwordField, 'on')
    sinon.stub(@auth.login, 'bind').returns(@auth.login)
    sinon.stub(@auth.removeFieldsError, 'bind').returns(@auth.removeFieldsError)

    @auth.addEvents()

    assert(@auth.nodes.$loginForm.on.calledWith('submit', @auth.login), 'Invalid event or handler for $loginForm')

    assert(
      @auth.nodes.$emailField.on.calledWith('focus', @auth.removeFieldsError),
      'Invalid event or handler for $emailField'
    )

    assert(
      @auth.nodes.$passwordField.on.calledWith('focus', @auth.removeFieldsError),
      'Invalid event or handler for $passwordField'
    )

    @auth.nodes.$loginForm.on.restore()
    @auth.nodes.$emailField.on.restore()
    @auth.nodes.$passwordField.on.restore()
    @auth.login.bind.restore()
    @auth.removeFieldsError.bind.restore()
    done()

  it '#initialize', (done) ->
    sinon.stub(@auth.nodes.$error, 'addClass');

    @auth.initialize()

    assert(@auth.nodes.$error.addClass.calledWith('modal-message'), 'js class wasn\'t added')

    @auth.nodes.$error.addClass.restore()
    done()

  it '#login authenticates in app', (done) ->
    sinon.stub(@auth.ajax, 'create')
    event =
      preventDefault: sinon.stub()

    @auth.login(event)

    assert(@auth.ajax.create.called, 'response wasn\'t sent')

    @auth.ajax.create.restore()
    done()

  context '#showError', ->
    beforeEach ->
      @classes =
        addClass: sinon.stub()

      @message = 'some error'
      @clock = sinon.useFakeTimers()
      sinon.stub(@auth.nodes.$emailField, 'parents').returns(@classes)
      sinon.stub(@auth.nodes.$passwordField, 'parents').returns(@classes)
      sinon.stub(@auth.nodes.$passwordField, 'val')
      sinon.stub(@auth.nodes.$errorContent, 'html')
      sinon.stub(@auth.nodes.$error, 'fadeIn')

    afterEach ->
      @auth.nodes.$emailField.parents.restore()
      @auth.nodes.$passwordField.parents.restore()
      @auth.nodes.$passwordField.val.restore()
      @auth.nodes.$errorContent.html.restore()
      @auth.nodes.$error.fadeIn.restore()
      @clock.restore()

    it 'shows error message', (done) ->
      @auth.showError(@message)

      assert(@auth.nodes.$errorContent.html.calledWith(@message), 'invalid message')
      assert(@auth.nodes.$error.fadeIn.called, 'message didn\'t show')
      done()

    it 'highlights fields', (done) ->
      @auth.showError(@message)

      assert(@classes.addClass.calledTwice, 'fields weren\'t highlighted')
      done()

    it 'hides error message in 3 seconds', (done) ->
      clearError = sinon.stub()
      sinon.stub(@auth.clearError, 'bind').returns(clearError)

      @auth.showError(@message)
      @clock.tick(3000)

      assert(clearError.called, 'error message wasn\'t hidden')

      @auth.clearError.bind.restore()
      done()

  context '#removeFieldsError', ->
    it 'hides highlight', (done) ->
      @auth.isActiveError = true

      @auth.removeFieldsError()

      assert.isFalse(@auth.isActiveError, 'error wasn\t hidden')
      done()

    it 'does nothing if error is hidden', (done) ->
      assert.notOk(@auth.isActiveError, 'invalid value of isActiveError')

      @auth.removeFieldsError()

      assert.notOk(@auth.isActiveError, 'invalid value of isActiveError')
      done()