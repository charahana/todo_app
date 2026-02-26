class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :authorize_admin!, only: [:create, :destroy, :update]

  def create
    user = User.find(params[:user_id])
    @organization.memberships.create(user: user, role: params[:role])
    redirect_to @organization, notice: "ユーザーを追加しました"
  end

  def update
    memberships = @organization.memberships.find(params[:id])
    membership.update(role: params[:role])
    redirect_to @organization, notice: "権限を更新しました"
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
