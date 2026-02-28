class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum role: { member: 0, admin: 1 }

  validate :cannot_demote_last_admin, if: :will_save_change_to_role?
  before_destroy :cannot_destroy_last_admin
  before_update :cannot_demote_last_admin

  private

  def cannot_destroy_last_admin
    if admin? && organization.memberships.admin.count == 1
      errors.add(:base, "最後の管理者は削除または変更できません")
      throw :abort
    end
  end

  def cannot_demote_last_admin
    if role_changed? && role_was == "admin" && role != "admin" && organization.memberships.admin.count == 1
      errors.add(:base, "最後の管理者は削除または変更できません")
      throw :abort
    end
  end
end
