require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MembershipsHelper. For example:
#
# describe MembershipsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe MembershipsHelper, type: :helper do
  describe "#role_label" do
    it "returns '管理者' for admin role" do
      membership = build(:membership, role: :admin)
      expect(helper.role_label(membership)).to eq("管理者")
    end

    it "returns 'メンバー' for member role" do
      membership = build(:membership, role: :member)
      expect(helper.role_label(membership)).to eq("メンバー")
    end
  end
end

module MembershipsHelper
  def role_label(membership)
    membership.admin? ? "管理者" : "メンバー"
  end
end