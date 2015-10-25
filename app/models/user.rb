class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  include PgSearch

  has_many :comments
  has_many :articles
  belongs_to :role

  before_create :set_default_role

  validates :name, presence: true,
                   length: { minimum: 2, maximum: 30 }

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  pg_search_scope :search,
                  against: [:name, :email],
                  :using => {
                      :tsearch => {:prefix => true}
                  }

  def admin?
    role.name == 'admin'
  end

  private

  def set_default_role
    self.role ||= Role.find_by_name('registered')
  end

end
