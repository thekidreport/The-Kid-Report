class MembershipsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :site_admin_required!
  
  def index
    @memberships = @site.memberships.includes(:user).order('memberships.role_id desc, users.name asc, users.email asc').all.paginate(:page => params[:page], :per_page => 20)
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
    @membership.user.generate_reset_password_token!
    
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
  
  
  def build_many
    # nothing to do here.
  end
  
  def create_many
    potential_emails = params[:membership_emails].split(/[<>\s,'"]+/)
    potential_emails = potential_emails.select{|e| e =~ User::EMAIL_REGEX }
    memberships_added_count = 0
    for potential_email in potential_emails
      membership = @site.memberships.build(:email => potential_email, :role => Role.member) 
      if membership.save
        memberships_added_count += 1
      end
    end
    flash[:notice] = "#{memberships_added_count} membership#{memberships_added_count != 1 ? 's were' : ' was'  } created"
    redirect_to site_memberships_path(@site)
  end
  
end
