class Article < ActiveRecord::Base

  has_many :comments, dependent: :destroy
  belongs_to :user

  validates :title, length: { minimum: 2 }
  validates :content, length: { minimum: 2 }

  searchable do
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

end
