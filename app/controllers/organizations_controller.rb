class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:show, :destroy, :switch]
  before_action :authorize_admin!, only: [:destroy]

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
    redirect_to organization_path(@organization), notice: "組織を作成しました"
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def show
    @memberships = @organization.memberships.includes(:user)
    @membership = @organization.memberships.new
  end

  def destroy
    if current_user.organizations.count == 1
      redirect_to organizations_path, alert: "最後の組織は削除できません"
      return
    end
    if @organization.destroy
      redirect_to organizations_path, notice: "組織を削除しました"
    else
      redirect_to organizations_path, alert: @organization.errors.full_messages.to_sentence
    end
  end

  def switch
    session[:organization_id] = organization.id
    redirect_to organization_path(organization), notice: "組織を切り替えました"
  end
  
  private

  def set_organization
    @organization = current_user.organizations.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name)
  end

  def authorize_admin!
    membership = @organization.memberships.find_by(user: current_user)
    redirect_to @organization, alert: "権限がありません" unless membership&.admin?
  end
end
