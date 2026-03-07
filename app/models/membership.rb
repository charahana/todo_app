class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum role: { member: 0, admin: 1 }

  before_update :prevent_last_admin_demotion
  before_destroy :prevent_last_admin_destroy

  private

  def prevent_last_admin_demotion
    if role_changed? && role_was == "admin" && organization.memberships.admin.count == 1
      errors.add(:base, "最後の管理者は削除または変更できません")
      throw :abort
    end
  end

  def prevent_last_admin_destroy
    if admin? && organization.memberships.admin.count == 1
      errors.add(:base, "最後の管理者は削除または変更できません")
      throw :abort
    end
  end
end
