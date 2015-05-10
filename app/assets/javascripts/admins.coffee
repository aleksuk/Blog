class Blog.Administration extends Blog.Base

  usersPage: 1

  articlesPage: 1

  usersUrl: 'admin/users'

  articlesUrl: 'admin/articles'

  searchType: 'article'

  searchUrls:
    user: '/search/user'
    article: '/search/article'

  findNodes: ->
    @nodes =
      $body: @body
      $usersList: @body.find('.users-list')
      $modal: @body.find('.modal')
      $modalContent: @body.find('.modal-content')
      $error: @body.find('.admin-error')
      $errorContent: @body.find('.admin-error-content')
      $success: @body.find('.admin-success')
      $successContent: @body.find('.admin-success-content')
      $warning: @body.find('.admin-warning')
      $warningContent: @body.find('.admin-warning-content')
      $nextUsers: @body.find('.next-users')
      $prevUsers: @body.find('.prev-users')
      $articlesList: @body.find('.articles-list')
      $nextArticles: @body.find('.next-articles')
      $prevArticles: @body.find('.prev-articles')
      $searchButton: @body.find('.admin-search .search-btn')
      $searchTypeText: @body.find('.search-type .text')
      $searchTypeDropdown: @body.find('.search-type-dropdown')
      $searchResult: @body.find('.admin-search-result')
      $searchResultContent: @body.find('.admin-search-result .content')
      $closeSearch: @body.find('.close-search')
      $searchInput: @body.find('.admin-search-input')

  addEvents: ->
    @nodes.$body.on('click', '.user', @editUser.bind(@))
    @nodes.$modal.on('click', '.btn-modal-save', @done.bind(@))
    @nodes.$nextUsers.on('click', @nextUsers.bind(@))
    @nodes.$prevUsers.on('click', @prevUsers.bind(@))
    @nodes.$nextArticles.on('click', @nextArticles.bind(@))
    @nodes.$prevArticles.on('click', @prevArticles.bind(@))
    @nodes.$searchTypeDropdown.on('click', 'li', @changeSearchType.bind(@))
    @nodes.$searchButton.on('click', @search.bind(@))
    @nodes.$closeSearch.on('click', @closeSearch.bind(@))

  editUser: (e) ->
    @userData = $(e.currentTarget).data()
    @action = 'updateUser'
    $template = $(@getTemplate('edit-user-template'))
    $template.find('.id').val(@userData.id)
    $template.find('.name').val(@userData.name)
    $template.find('.email').val(@userData.email)
    $template.find('.role').val(@userData.role)

    @nodes.$modalContent.empty()
    @nodes.$modalContent.append($template)
    @nodes.$modal.modal('show')

  getTemplate: (template) ->
    content = document.getElementById(template).content;
    return document.importNode(content, true);

  done: ->
    @[@action]()
    @nodes.$modal.modal('hide')

  updateUser: ->
    @ajax.update(
      url: '/admin/user'
      data:
        user:
          id: @nodes.$modal.find('.id').val()
          name: @nodes.$modal.find('.name').val()
          email: @nodes.$modal.find('.email').val()
          role_id: @nodes.$modal.find('.role').val()
      success: @updateUserView.bind(@)
      error: ((response) ->
        error = if $.isArray(response.responseJSON)
          response.responseJSON.join('<br />')
        else
          response.responseText

        @showError(error)
      ).bind(@)
    )

  changePage: (url, params) ->
    if @promise
      return

    @promise = @ajax.get(
      url: url,
      data:
        page: params.page
      success: ((response) ->
        @promise = null
        @updateTable(response, params)
      ).bind(@)
    )

  nextUsers: ->
    page = @usersPage + 1
    @changePage(@usersUrl, page: page, changedPage: 'usersPage', $table: @nodes.$usersList)

  prevUsers: ->
    page = @usersPage - 1

    if page < 1
      return

    @changePage(@usersUrl, page: page, changedPage: 'usersPage', $table: @nodes.$usersList)

  nextArticles: ->
    page = @articlesPage + 1
    @changePage(@articlesUrl, page: page, changedPage: 'articlesPage', $table: @nodes.$articlesList)

  prevArticles: ->
    page = @articlesPage - 1

    if page < 1
      return

    @changePage(@articlesUrl, page: page, changedPage: 'articlesPage', $table: @nodes.$articlesList)

  updateTable: (data, params) ->
    result = data.match(/<tbody>([\s\S]*)<\/tbody>/)[1].trim()

    if result
      @[params.changedPage] = params.page
      params.$table
        .find('tbody')
        .html(result)

  updateUserView: (response) ->
    @nodes.$usersList.find('[data-id=' + @userData.id + ']').replaceWith(response)
    @showSuccess('Данные пользователя обновлены!')

  changeSearchType: (e) ->
    target = $(e.currentTarget)
    data = target.data()

    @searchType = data.type
    @nodes.$searchTypeText.html(data.text)

  search: ->
    url = @searchUrls[@searchType]

    @ajax.get(
      url: url
      data:
        query: @nodes.$searchInput.val()
      success: @renderSearchResult.bind(@)
      error: @searchError.bind(@)
    )

  renderSearchResult: (content) ->
    @nodes.$searchResultContent.html(content);
    @nodes.$searchInput.val('')
    @nodes.$searchResult.fadeIn()

  closeSearch: ->
    @nodes.$searchResult.fadeOut()

  searchError: (response) ->
    @showWarning(response.responseText)