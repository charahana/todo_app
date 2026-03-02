require 'rails_helper'

RSpec.describe "Organizations", type: :request do
  let(:user)         { create(:user) }
  let(:other_user)   { create(:user) }
  let(:organization) { create(:organization) }

  before do
    sign_in user
  end

  describe "GET /organizations/:id" do
    context "when user belongs to the organization" do
      before do
        create(:membership, user: user, organization: organization, role: :admin)
      end

      it "returns 200 OK" do
        get organization_path(organization)
        expect(response).to have_http_status(:ok)
      end

      it "displays the organization name" do
        get organization_path(organization)
        expect(response.body).to include(organization.name)
      end
    end

    context "when user does not belong to the organization" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          get organization_path(organization)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
