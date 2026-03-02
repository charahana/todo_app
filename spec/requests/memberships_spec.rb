require 'rails_helper'

RSpec.describe "Memberships", type: :request do
  let(:admin_user) { create(:user) }
  let(:member_user) { create(:user) }
  let(:organization) { create(:organization) }

  before do
    organization.memberships.create(user: admin_user, role: :admin)
    sign_in admin_user
  end

  describe "GET /index" do
    it "returns 200" do
      get organization_memberships_path(organization)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "adds a new member" do
      post organization_memberships_path(organization), params: { membership: { user_id: member_user.id, role: :member } }
      expect(organization.users).to include(member_user)
      expect(response).to redirect_to(organization_memberships_path(organization))
    end
  end

  describe "PATCH /update" do
    it "updates role" do
      membership = organization.memberships.create(user: member_user, role: :member)
  
      patch organization_membership_path(organization, membership),
            params: { membership: { role: :admin } }
  
      expect(membership.reload.admin?).to be true
    end
  end

  describe "DELETE /destroy" do
    it "removes member" do
      membership = organization.memberships.create(user: member_user, role: :member)
  
      expect {
        delete organization_membership_path(organization, membership)
      }.to change { organization.memberships.count }.by(-1)
    end
  end

  describe "last admin protection (request spec)" do
    context "when only one admin exists" do
      it "does not allow deleting the last admin" do
        membership = organization.memberships.find_by(user: admin_user)
  
        expect {
          delete organization_membership_path(organization, membership)
        }.not_to change { organization.memberships.count }
  
        expect(response).to redirect_to(organization_memberships_path(organization))
        expect(flash[:alert]).to be_present
      end
  
      it "does not allow demoting the last admin" do
        membership = organization.memberships.find_by(user: admin_user)
  
        patch organization_membership_path(organization, membership),params: { membership: { role: :member } }
  
        expect(membership.reload.admin?).to be true
        expect(flash[:alert]).to be_present
      end
    end
  end
end