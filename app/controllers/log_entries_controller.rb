class LogEntriesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @log_entries = @site.log_entries.order('created_at desc').paginate(:page => params[:page])
  end

end