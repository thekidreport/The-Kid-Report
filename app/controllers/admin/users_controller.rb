class Admin::UsersController < Admin::AdminController
  
  def index
    @page_title = 'Users'
    @users = User.all.paginate
  end

  def show
    @user = User.find(params[:id])
  end

end