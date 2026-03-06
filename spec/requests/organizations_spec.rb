require 'rails_helper'

RSpec.describe "Organizations", type: :request do
  let(:admin_user)   { create(:user, name: "AdminUser") }
  let(:member_user)  { create(:user, name: "MemberUser") }
  let(:non_member)   { create(:user, name: "NonMember") }
  let!(:organization) { create(:organization, name: "TodoApp") }

  before do
    organization.memberships.create!(user: admin_user, role: :admin)
  end

  describe "GET /organizations/:id" do
    context "as admin member" do
      before { sign_in admin_user }

      it "returns 200 OK and shows org name" do
        get organization_path(organization)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("TodoApp")
      end

      it "displays members and member addition form" do
        organization.memberships.create!(user: member_user, role: :member)

        get organization_path(organization)
        expect(response.body).to include("AdminUser")
        expect(response.body).to include("MemberUser")
        expect(response.body).to include("user_id")
        expect(response.body).to include("role")
        expect(response.body).to include("追加")
      end
    end

    context "as regular member" do
      before do
        organization.memberships.create!(user: member_user, role: :member)
        sign_in member_user
      end

      it "does not show member addition form" do
        get organization_path(organization)
        expect(response.body).not_to include("user_id")
        expect(response.body).not_to include("role")
        expect(response.body).not_to include("追加")
      end
    end

    context "as non-member" do
      before { sign_in non_member }

      it "raises ActiveRecord::RecordNotFound" do
        expect { get organization_path(organization) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /memberships" do
    before { sign_in admin_user }

    it "adds a new member" do
      expect {
        post organization_memberships_path(organization),
             params: { membership: { user_id: member_user.id, role: :member } }
      }.to change { organization.memberships.count }.by(1)

      expect(response).to redirect_to(organization_memberships_path(organization))
    end
  end

  describe "PATCH /memberships/:id" do
    before { sign_in admin_user }

    it "updates member role" do
      membership = organization.memberships.create!(user: member_user, role: :member)

      patch organization_membership_path(organization, membership),
            params: { membership: { role: :admin } }

      expect(membership.reload.admin?).to be true
      expect(response).to redirect_to(organization_memberships_path(organization))
    end

    it "does not allow demoting last admin" do
      membership = organization.memberships.find_by(user: admin_user)

      patch organization_membership_path(organization, membership),
            params: { membership: { role: :member } }

      expect(membership.reload.admin?).to be true
      expect(flash[:alert]).to be_present
    end
  end

  describe "DELETE /memberships/:id" do
    before { sign_in admin_user }

    it "removes a member" do
      membership = organization.memberships.create!(user: member_user, role: :member)

      expect {
        delete organization_membership_path(organization, membership)
      }.to change { organization.memberships.count }.by(-1)

      expect(response).to redirect_to(organization_memberships_path(organization))
    end

    it "does not allow deleting last admin" do
      membership = organization.memberships.find_by(user: admin_user)

      expect {
        delete organization_membership_path(organization, membership)
      }.not_to change { organization.memberships.count }

      expect(flash[:alert]).to be_present
    end
  end

  describe "POST /organizations" do
    before { sign_in admin_user }
  
    it "creates a new organization" do
      expect {
        post organizations_path,
             params: { organization: { name: "NewOrg" } }
      }.to change(Organization, :count).by(1)
  
      expect(response).to redirect_to(organization_path(Organization.last))
    end
  
    it "adds creator as admin member" do
      post organizations_path,
           params: { organization: { name: "NewOrg" } }
  
      organization = Organization.last
      membership = organization.memberships.find_by(user: admin_user)
  
      expect(membership).to be_present
      expect(membership.admin?).to be true
    end
  end
end