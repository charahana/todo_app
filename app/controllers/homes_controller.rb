class HomesController < ApplicationController
  def top
    redirect_to root_path if user_signed_in?
  end

  def about
  end
end
