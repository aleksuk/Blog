class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  validates :body, length: { minimum: 2 }
end
