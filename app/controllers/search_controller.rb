class SearchController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:index]

  def index
    target = params[:query]

    unless target && target.size > 0
      return @articles = []
    end

    query = Article.search do
      fulltext params[:query] || ' '
      paginate page: params[:page] || 1, per_page: 10
    end

    @articles = query.results
    @pagination = @articles
  end

end
