#= spec_helper

describe 'Blog.Ajax', ->
  beforeEach ->
    sinon.stub($, 'ajax');

    @params =
      url: 'some/url'
      data: {}
      success: ->
      error: ->
      dataType: 'JSON'

    @ajax = new Blog.Ajax()

  afterEach ->
    $.ajax.restore()

  it 'constructor', (done) ->
    ajax = new Blog.Ajax()

    assert.equal(@ajax, ajax, 'ajax wasn\'t initialized')
    done()

  it '#create send ajax request by method POST', (done) ->
    @params.method = 'POST'
    @ajax.create(@params)

    assert($.ajax.calledWithMatch(@params), 'request wasn\'t sent')
    done()

  it '#get send ajax request by method GET', (done) ->
    @ajax.get(@params)

    assert($.ajax.calledWithMatch(@params), 'request wasn\'t sent')
    done()

  it '#update send ajax request by method PATCH', (done) ->
    @params.method = 'PATCH'
    @ajax.update(@params)

    assert($.ajax.calledWithMatch(@params), 'request wasn\'t sent')
    done()

  it '#destroy send ajax request by method DELETE', (done) ->
    @params.method = 'DELETE'
    @ajax.destroy(@params)

    assert($.ajax.calledWithMatch(@params), 'request wasn\'t sent')
    done()