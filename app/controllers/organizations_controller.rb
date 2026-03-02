class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @organizations = current_user.organizations
  end
  
  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    ActiveRecord::Base.transaction do
      @organization.save!
      @organization.memberships.create!(user: current_user, role: :admin)
    end
    redirect_to organizations_path, notice: "組織を作成しました"
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def show
    @organization = current_user.organizations.find(params[:id])
    @memberships = @organization.memberships.includes(:user)
    @membership = @organization.memberships.new
  end
  
  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
