class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :select_layout

  before_filter :redirect_to_www
  before_filter :load_site
  before_filter :ensure_membership
  before_filter :set_time_zone
  
  def show
    @example = Site.example
    @recent_users = User.limit(5).order('created_at desc')
    @recent_sites = Site.limit(5).order('created_at desc')
  end
  
  def select_layout
    if @site && !@site.new_record?
      'site'
    else
      'application'
    end
  end
  
  def site_admin_required!
    unless current_user && current_user.can_admin?(@site)
      flash[:notice] = 'You are not allowed to go to that page'
      redirect_to permalink_path(@site.permalink, @site.home_page.try(:permalink))
      return false
    end
  end
  
  def site_editor_required!
    unless current_user && current_user.can_edit?(@site)
      flash[:notice] = 'You are not allowed to go to that page'
      redirect_to permalink_path(@site.permalink, @site.home_page.try(:permalink))
      return false
    end
  end
  
  def site_member_required!
    unless current_user && current_user.member_of?(@site)
      flash[:notice] = 'You are not allowed to go to that page'
      redirect_to permalink_path(@site.permalink, @site.home_page.try(:permalink))
      return false
    end
  end
  
  private
  def load_site
    if params[:site_permalink]
      @site = Site.not_deleted.find_by_permalink(params[:site_permalink]) 
      unless @site
        render :text => 'Site not found', :status => :not_found
        return false
      end
    elsif params[:site_id]
      @site = Site.not_deleted.find(params[:site_id]) 
      unless @site
        render :text => 'Site not found', :status => :not_found
        return false
      end
    end
    @breadcrumbs = [] if @site
  end
  
  def site_members_only
    @site && @site.members_only?
  end
  
  def ensure_membership
    if current_user && @site && @site.members_only? && !current_user.member_of?(@site)
      redirect_to new_site_membership_path(@site)
    end
  end
  
  def set_time_zone
    Time.zone = @site.time_zone if @site
  end

  def redirect_to_www
    if Rails.env.production?
      redirect_to("https://www." + request.host_with_port + request.request_uri, :status => 301) and return if !(request.domain(2) =~ /www/) && (request.protocol == 'http://')
      redirect_to(request.protocol + "www." + request.host_with_port + request.request_uri, :status => 301) and return if !(request.domain(2) =~ /www/)
      redirect_to("https://" + request.host_with_port + request.request_uri, :status => 301) and return if (request.protocol == 'http://')
    end
  end
  
end
