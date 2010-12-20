class Admin::AdminController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :require_admin_user
  
  def require_admin_user
    unless current_user.admin?
      render :text => 'You are not authorized to take this action.  <a href="/users/sign_out">Sign Out</a>'
    end
  end

end
