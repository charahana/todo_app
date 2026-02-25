class UsersController < ApplicationController
  def show
    @user = current_user
    @tasks = @user.tasks.order(created_at: :desc)
  end

  def edit
    redirect_to about_path unless @user == current_user
  end

  def update
    if @user.update(user_params)
      redirect_to show_users_path, notice: "プロフィールを更新しました"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end
end
