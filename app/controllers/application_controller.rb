class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :select_layout

  before_filter :redirect_to_www
  before_filter :load_site
  before_filter :set_user_time_zone
  
  
  def select_layout
    if @site && !@site.new_record?
      'site'
    else
      'application'
    end
  end
  
  def site_admin_required!
    unless current_user.can_admin?(@site)
      flash[:notice] = 'You are not allowed to go to that page'
      redirect_to permalink_path(@site.permalink, @site.home_page.try(:permalink))
      return false
    end
  end
  
  def site_editor_required!
    unless current_user.can_edit?(@site)
      flash[:notice] = 'You are not allowed to go to that page'
      redirect_to permalink_path(@site.permalink, @site.home_page.try(:permalink))
      return false
    end
  end
  
  def site_member_required!
    unless current_user.member_of?(@site)
      flash[:notice] = 'You are not allowed to go to that page'
      redirect_to permalink_path(@site.permalink, @site.home_page.try(:permalink))
      return false
    end
  end
  
  private
  def load_site
    if params[:site_permalink]
      @site = Site.find_by_permalink(params[:site_permalink]) 
    elsif params[:site_id]
      @site = Site.find(params[:site_id]) 
    end
  end
  
  def set_user_time_zone
    Time.zone = @site.time_zone if @site
  end

  def redirect_to_www
    if Rails.env.production?
      redirect_to(request.protocol + 'www.thekidreport.org' + request.request_uri, :status => 301) and return if !(request.domain(2) =~ /www/)
    end
  end
  
end
