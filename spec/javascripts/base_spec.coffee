#= spec_helper

describe 'Blog.Base', ->
  beforeEach ->
    @base = new Blog.Base()

  it 'constructor', (done) ->
    sinon.stub(@base, 'initialize')
    sinon.stub(@base, 'findNodes')
    sinon.stub(@base, 'addEvents')

    @base.constructor()

    assert(@base.initialize.called, '#initialize method was\'t called')
    assert(@base.findNodes.called, '#findNodes method was\'t called')
    assert(@base.addEvents.called, '#addEvents method was\'t called')
    done()

  it '#findNodes creates object with nodes', (done) ->
    delete @base.nodes

    assert.isUndefined(@base.nodes, 'nodes have still available')

    @base.findNodes()

    assert.isObject(@base.nodes, 'nodes weren\'t available')
    done()

  it '#showError shows error message', (done) ->
    errorMessage = 'some error'
    @base.findNodes()

    sinon.stub(window, 'clearInterval')
    sinon.stub(window, 'setTimeout')
    sinon.stub(@base.nodes.$errorContent, 'html')
    sinon.stub(@base.nodes.$error, 'fadeIn')

    @base.showError(errorMessage)

    assert(@base.nodes.$errorContent.html.calledWith(errorMessage), 'error message wasn\'t showed')
    assert(@base.nodes.$error.fadeIn.called, '#fadeIn error message wasn\'t showed')

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

    assert(@base.nodes.$successContent.html.calledWith(successMessage), 'success message wasn\'t showed')
    assert(@base.nodes.$success.fadeIn.called, '#fadeIn success message wasn\'t showed')

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

    assert(@base.nodes.$warningContent.html.calledWith(warningMessage), 'warning message wasn\'t showed')
    assert(@base.nodes.$warning.fadeIn.called, '#fadeIn warning message wasn\'t showed')

    setTimeout.restore()
    clearInterval.restore()
    @base.nodes.$warning.fadeIn.restore()
    @base.nodes.$warningContent.html.restore()
    done()

  it '#clearError hides error message', (done) ->
    @base.findNodes()

    sinon.stub(@base.nodes.$error, 'fadeOut')
    @base.clearError()

    assert(@base.nodes.$error.fadeOut.called, 'error messages weren\'t hidden');

    @base.nodes.$error.fadeOut.restore()
    done()

  it '#clearSuccess hides success message', (done) ->
    @base.findNodes()

    sinon.stub(@base.nodes.$success, 'fadeOut')
    @base.clearSuccess()

    assert(@base.nodes.$success.fadeOut.called, 'success messages weren\'t hidden')

    @base.nodes.$success.fadeOut.restore()
    done()

  it '#clearWarning hides warning message', (done) ->
    @base.findNodes()

    sinon.stub(@base.nodes.$warning, 'fadeOut')
    @base.clearWarning()

    assert(@base.nodes.$warning.fadeOut.called, 'warning messages weren\'t hidden')

    @base.nodes.$warning.fadeOut.restore()
    done()

  it '#relocate relocate on other page', (done) ->
    path = '/'
    sinon.stub(window.location, 'assign')

    @base.relocate(path)

    assert(window.location.assign.calledWith(path), 'location wasn\'t changed')

    window.location.assign.restore()
    done()

  it '#openMainPage relocates on main page', (done) ->
    mainPagePath = '/'
    sinon.stub(@base, 'relocate')

    @base.openMainPage()

    assert(@base.relocate.calledWith(mainPagePath), 'main page wasn\'t opened')
    done()

  it '#parseError parses json error into string', (done) ->
    response =
      responseJSON:
        errors:
          error: ['message'],
          error2: ['message2']

    result = "error message <br />error2 message2 <br />"

    sinon.stub(@base, 'showError')
    @base.parseError(response)

    assert(@base.showError.calledWith(result))
    done()
