module ArticlesHelper

  def parse_article content
    if action_name == 'index'
      truncate(content, length: 1500, omission: ' ...')
    else
      content
    end
  end

  def need_pagination?
    controller_name && action_name == 'index'
  end

  def get_article_button_text article
    if article.new_record?
      t('articles.createArticle')
    else
      t('articles.updateArticle')
    end
  end

end
