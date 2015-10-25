class Article < ActiveRecord::Base

  include PgSearch

  has_many :comments, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user

  validates :title, length: { minimum: 2 }
  validates :content, length: { minimum: 2 }

  pg_search_scope :search,
                  against: [:title, :content],
                  associated_against: {
                      tags: [:name]
                  },
                  :using => {
                      :tsearch => {:prefix => true}
                  }

  def article_tags
    self.tags.collect(&:name).join(', ')
  end

  def article_tags=(tags_list)
    tags_arr = check_tags(tags_list)

    tags = Tag.where(name: tags_arr) || []

    self.tags = tags
  end

  private

  def check_tags tags_list
    return [] unless tags_list.present?
    tags = tags_list.split(/\s*,\s*/)

    tags.each do |el|
      unless Tag.find_by_name(el)
        Tag.create(name: el)
      end
    end

    tags
  end

end
