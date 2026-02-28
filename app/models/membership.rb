class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum role: { member: 0, admin: 1 }

  validate :cannot_remove_last_admin, if: :will_be_non_admin?

  private

  def will_be_non_admin?
    admin? && (role_changed? || destroyed?)
  end

  def cannot_remove_last_admin
    if organization.memberships.admin.count == 1
      errors.add(:base, "最後の管理者は削除または変更出来ません")
    end
  end
end
