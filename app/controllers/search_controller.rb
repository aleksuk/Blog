class SearchController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:index]
  before_action :check_permission, except: [:index]

  def index
    target = params[:query]

    unless target && target.size > 0
      return @articles = []
    end

    query = find_in Article

    @articles = query.results
    @pagination = @articles
  end

  def find_article
    index

    create_response(@articles, 'admins/_articles')
  end

  def find_user
    query = find_in User

    @users = query.results
    create_response(@users, 'admins/_users')
  end

  private

  def find_in object
    object.search do
      fulltext params[:query]
      paginate page: params[:page] || 1, per_page: 10
    end
  end

  def create_response data, partial
    if data.size > 0
      render partial, layout: false
    else
      render status: 422, text: t('search.error')
    end
  end

end
