module ArticlesHelper

  def get_article_button_text article
    if article.new_record?
      t('articles.createArticle')
    else
      t('articles.updateArticle')
    end
  end

end
