class UsersController < ApplicationController
  
  def destroy
    @user = current_user
    @user.mark_deleted!
    flash[:confirm] = "The account has been deleted"
    redirect_to root_path
  end

end