class Article < ActiveRecord::Base

  has_many :comments, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user

  validates :title, length: { minimum: 2 }
  validates :content, length: { minimum: 2 }

  searchable do
    text :article_tags,  boost: 3
    text :title, boost: 2
    text :content

    # integer :user_id
    # time :created_at
    # time :updated_at
    #
    # string  :sort_title do
    #   title.downcase.gsub(/^(an?|the)/, '')
    # end
  end

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
