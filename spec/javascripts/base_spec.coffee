#= spec_helper

describe 'Blog.Base', ->
  beforeEach ->
    @base = new Blog.Base()

  it 'constructor', (done) ->
    sinon.stub(@base, 'initialize')
    sinon.stub(@base, 'findNodes')
    sinon.stub(@base, 'addEvents')

    @base.constructor()

    assert(@base.initialize.called)
    assert(@base.findNodes.called)
    assert(@base.addEvents.called)
    done()

  it '#findNodes creates object with nodes', (done) ->
    @base.findNodes()
    keys = [
      '$success',
      '$error',
      '$errorContent',
      '$successContent',
      '$warning',
      '$warningContent'
    ]

    expect(@base.nodes).to.include.keys(keys)
    done()

  it '#showError shows error message', (done) ->
    errorMessage = 'some error'
    @base.findNodes()

    sinon.stub(window, 'clearInterval')
    sinon.stub(window, 'setTimeout')
    sinon.stub(@base.nodes.$errorContent, 'html')
    sinon.stub(@base.nodes.$error, 'fadeIn')

    @base.showError(errorMessage)

    assert(@base.nodes.$errorContent.html.calledWith(errorMessage))
    assert(@base.nodes.$error.fadeIn.called)

    setTimeout.restore()
    clearInterval.restore()
    @base.nodes.$error.fadeIn.restore()
    @base.nodes.$errorContent.html.restore()
    done()

  it '#showSuccess shows success message', (done) ->
    successMessage = 'some success'
    @base.findNodes()

    sinon.stub(window, 'clearInterval')
    sinon.stub(window, 'setTimeout')
    sinon.stub(@base.nodes.$successContent, 'html')
    sinon.stub(@base.nodes.$success, 'fadeIn')

    @base.showSuccess(successMessage)

    assert(@base.nodes.$successContent.html.calledWith(successMessage))
    assert(@base.nodes.$success.fadeIn.called)

    setTimeout.restore()
    clearInterval.restore()
    @base.nodes.$success.fadeIn.restore()
    @base.nodes.$successContent.html.restore()
    done()

  it '#showWarning shows warning message', (done) ->
    warningMessage = 'some warning'
    @base.findNodes()

    sinon.stub(window, 'clearInterval')
    sinon.stub(window, 'setTimeout')
    sinon.stub(@base.nodes.$warningContent, 'html')
    sinon.stub(@base.nodes.$warning, 'fadeIn')

    @base.showWarning(warningMessage)

    assert(@base.nodes.$warningContent.html.calledWith(warningMessage))
    assert(@base.nodes.$warning.fadeIn.called)

    setTimeout.restore()
    clearInterval.restore()
    @base.nodes.$warning.fadeIn.restore()
    @base.nodes.$warningContent.html.restore()
    done()

  it '#clearError hides error message', (done) ->
    @base.findNodes()

    sinon.stub(@base.nodes.$error, 'fadeOut')
    @base.clearError()

    assert(@base.nodes.$error.fadeOut.called);

    @base.nodes.$error.fadeOut.restore()
    done()

  it '#clearSuccess hides success message', (done) ->
    @base.findNodes()

    sinon.stub(@base.nodes.$success, 'fadeOut')
    @base.clearSuccess()

    assert(@base.nodes.$success.fadeOut.called)

    @base.nodes.$success.fadeOut.restore()
    done()

  it '#clearWarning hides warning message', (done) ->
    @base.findNodes()

    sinon.stub(@base.nodes.$warning, 'fadeOut')
    @base.clearWarning()

    assert(@base.nodes.$warning.fadeOut.called)

    @base.nodes.$warning.fadeOut.restore()
    done()

  it '#relocate relocate on other page', (done) ->
    path = '/'
    sinon.stub(window.location, 'assign')

    @base.relocate(path)

    assert(window.location.assign.calledWith(path))

    window.location.assign.restore()
    done()

  it '#openMainPage relocates on main page', (done) ->
    mainPagePath = '/'
    sinon.stub(@base, 'relocate')

    @base.openMainPage()

    assert(@base.relocate.calledWith(mainPagePath))
    done()