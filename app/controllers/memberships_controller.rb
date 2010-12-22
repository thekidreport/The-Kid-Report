class MembershipsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :site_admin_required!
  
  def index
    @memberships = @site.memberships.paginate(:page => params[:page])
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
  
  def invite
    @membership = @site.memberships.find(params[:id])  
    Mailer::invite(@membership).deliver
    render :update do |page|
      page.replace "invite_#{dom_id(@membership)}", :text => "<span style='color:red'>Invite sent!</span>"
    end
  end

  def destroy
    @membership = @site.memberships.find(params[:id]) 
    @membership.destroy
    flash[:notice] = 'User \'' + @membership.user.display_name + '\' was successfully removed.'
    redirect_to site_memberships_path(@site)
  end
  
  def new
    @membership = @site.memberships.build
  end

  def create
    @membership = @site.memberships.build(params[:membership])
    if @membership.save
      redirect_to site_memberships_path(@site)
    else
      render :action => :new
    end
  end
  
  
end
