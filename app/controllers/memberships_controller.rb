class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :authorize_admin!, only: [:create, :destroy, :update]

  def index
    @memberships = @organization.memberships.includes(:user)
  end

  def create
    @membership = @organization.memberships.new(membership_params)

    if @membership.save
      redirect_to organization_memberships_path(@organization), notice: "メンバーを追加しました"
    else
      redirect_to @organization, alert: @membership.errors.full_messages.to_sentence
    end
  end

  def update
    membership = @organization.memberships.find(params[:id])

    if membership.update(membership_params)
      redirect_to organization_memberships_path(@organization), notice: "更新しました"
    else
      redirect_to organization_memberships_path(@organization),
                  alert: membership.errors.full_messages.to_sentence
    end
  end

  def destroy
    membership = @organization.memberships.find(params[:id])
    if membership.destroy
      redirect_to organization_memberships_path(@organization), notice: "ユーザーを削除しました"
    else
      redirect_to organization_memberships_path(@organization), alert: membership.errors.full_messages.to_sentence
    end
  end

  private

  def set_organization
    @organization = current_user.organizations.find(params[:organization_id])
  end

  def authorize_admin!
    membership = @organization.memberships.find_by(user: current_user)
    redirect_to @organization, alert: "Not authorized" unless membership&.admin?
  end

  def admin_user?
    @organization.memberships.find_by(user:current_user)&.admin?
  end

  def membership_params
    params.require(:membership).permit(:user_id, :role)
  end
end
