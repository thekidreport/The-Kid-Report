class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :select_layout

  before_filter :load_site
  before_filter :set_user_time_zone
  
  def select_layout
    if @site && !@site.new_record?
      'site'
    else
      'application'
    end
  end
  
  private
  def load_site
    @site = Site.find(params[:site_id]) if params[:site_id]
  end
  
  def set_user_time_zone
    Time.zone = @site.time_zone if @site
  end
  
end
