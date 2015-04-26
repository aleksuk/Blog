class Article < ActiveRecord::Base
  has_many :comments, dependent: :destroy

  validates :title, length: { minimum: 2 }
  validates :content, length: { minimum: 5 }

end
