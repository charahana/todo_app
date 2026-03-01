require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the OrganizationsHelper. For example:
#
# describe OrganizationsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe OrganizationsHelper, type: :helper do
  describe "#organization_name" do
    it "returns the organization name" do
      org = build(:organization, name: "TodoApp")
      expect(helper.organization_name(org)).to eq("TodoApp")
    end
  end
end

module OrganizationsHelper
  def organization_name(org)
    org.name
  end
end