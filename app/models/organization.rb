class Organization < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates :name, presence: true

  def admin?(user)
    memberships.find_by(user: user)&.admin?
  end
end
