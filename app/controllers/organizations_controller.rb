class OrganizationsController < ApplicationController
  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      @organization.memberships.create(user: current_user, role: :admin)
      redirect_to @organization, notice: "作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end
end
