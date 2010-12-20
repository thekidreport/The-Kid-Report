class LogEntriesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :site_editor_required!
  
  def index
    @log_entries = @site.log_entries.order('created_at desc').paginate(:page => params[:page])
  end

end