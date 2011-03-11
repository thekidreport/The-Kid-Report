class MembershipsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :site_admin_required!, :except => [:new, :create]
  skip_before_filter :ensure_membership, :only => [:new, :create]
  
  def index
    @memberships = @site.memberships.includes(:user).order('memberships.role_id desc, users.name asc, users.email asc').all.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @membership = @site.memberships.build
  end

  def create
    @membership = @site.memberships.build(params[:membership])
    @membership.role ||= Role.member
    @membership.user = current_user unless @membership.email.present?
    if @membership.save
      flash[:notice] = 'The member was successfully added.'
      Invitation.destroy_all("email = '#{@membership.user.email}'")
      
      if @membership.user == current_user
        redirect_to permalink_path(@site.permalink, @site.home_page.try(:permalink))
      else
        redirect_to new_site_membership_path(@site)
      end
    else
      render :action => :new
    end
  end
  
  def edit
    @page_title = "Edit members"
    @membership = @site.memberships.find(params[:id])
  end
  
  def update
    @membership = @site.memberships.find(params[:id])  
    if @membership.update_attributes(params[:membership])
    flash[:notice] = 'The member was successfully updated.'
      redirect_to site_memberships_path(@site)
    else
      render :action => :edit
    end
  end

  def destroy
    @membership = @site.memberships.find(params[:id]) 
    @membership.destroy
    flash[:notice] = 'User \'' + @membership.user.display_name + '\' was successfully removed.'
    redirect_to site_memberships_path(@site)
  end
  
end
