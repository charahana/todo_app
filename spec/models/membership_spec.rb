require 'rails_helper'

RSpec.describe Membership, type: :model do
  let(:organization) { create(:organization) }
  let(:admin_user)   { create(:user) }
  let(:member_user)  { create(:user) }

  describe "last admin protection" do
    context "when only one admin exists" do
      it "cannot be destroyed" do
        membership = create(:membership, organization: organization, user: admin_user, role: :admin)

        expect(membership.destroy).to be false
        expect(membership.errors[:base]).to include("最後の管理者は削除または変更できません")
      end

      it "cannot be demoted to member" do
        membership = create(:membership, organization: organization, user: admin_user, role: :admin)

        membership.role = :member
        expect(membership.save).to be false
        expect(membership.errors[:base]).to include("最後の管理者は削除または変更できません")
      end
    end

    context "when multiple admins exist" do
      it "allows destroying one admin" do
        create(:membership, organization: organization, user: admin_user, role: :admin)
        second_admin = create(:membership, organization: organization, user: member_user, role: :admin)

        expect(second_admin.destroy).to be_truthy
      end

      it "allows demoting one admin" do
        create(:membership, organization: organization, user: admin_user, role: :admin)
        second_admin = create(:membership, organization: organization, user: member_user, role: :admin)

        second_admin.role = :member
        expect(second_admin.save).to be_truthy
      end
    end
  end
end