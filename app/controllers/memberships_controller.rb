class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :authorize_admin!, only: [:create, :destroy, :update]

  def index
    @memberships = @organization.memberships.includes(:user)
  end

  def create
    user = User.find(params[:user_id])
    @organization.memberships.create(user: user, role: params[:role])
    redirect_to organization_memberships_path(@organization), notice: "ユーザーを追加しました"
  end

  def update
    membership = @organization.memberships.find(params[:id])
    if membership.update(role: params[:role])
      redirect_to organization_memberships_path(@organization)
    else
      redirect_to organization_memberships_path(@organization), alert: "Update failed"
    end
  end

  def destroy
    membership = @organization.memberships.find(params[:id])
    membership.destroy
    redirect_to @organization, notice: "ユーザーを削除しました"
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def authorize_admin!
    membership = @organization.memberships.find_by(user: current_user)
    redirect_to @organization, alert: "Not authorized" unless membership&.admin?
  end
end
