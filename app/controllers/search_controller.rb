class SearchController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:index]
  before_action :check_permission, except: [:index]

  def index
    return @articles = [] unless valid_query?(params[:query])

    @articles = find_in Article
    @pagination = @articles
  end

  def find_article
    index

    create_response(@articles, 'admins/_articles')
  end

  def find_user
    if valid_query?(params[:query])
      @users = find_in User
    else
      @users = []
    end

    create_response(@users, 'admins/_users')
  end

  private

  def find_in object
    object.search(params[:query])
        .page(params[:page])
        .per(10)
  end

  def valid_query? query
    query && query.size > 0
  end

  def create_response data, partial
    if data.size > 0
      render partial, layout: false
    else
      render status: 422, text: t('search.error')
    end
  end

end
