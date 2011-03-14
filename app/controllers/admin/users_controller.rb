class Admin::UsersController < Admin::AdminController
  
  def index
    @page_title = 'Users'
    users = User.not_deleted
    users = users.where("name iLike '%?%'", params[:name]) if params[:name].present?
    users = users.order('created_at desc')
    @users = users.paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.update_attribute(:admin, params[:user][:admin]) if current_user.admin?
    flash[:notice] = 'User was updated successfully'
    redirect_to admin_user_path(@user)
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.delete!
    flash[:notice] = 'User was deleted'
    redirect_to admin_users_path
  end
  
end