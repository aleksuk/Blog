class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

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

  searchable do
    text :name, :email
  end

  def admin?
    role.name == 'admin'
  end

  private

  def set_default_role
    self.role ||= Role.find_by_name('registered')
  end

end
