class MessagesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :site_editor_required!
  
  def index
    @messages = @site.messages.order("created_at desc").all.paginate(:page => params[:page], :per_page => 10)
  end
  
  def new
    @message = @site.messages.build(params[:message])
    if params[:page_id]  
      @page = @site.pages.find(params[:page_id])
      @message.page = @page
    end
  end
  
  def create
    @message = @site.messages.build(params[:message])
    @message.user = current_user
    if params[:page_id]  
      @page = @site.pages.find(params[:page_id])
      @message.page = @page
    end
    if @message.save
      flash[:notice] = 'Message was created and notifications are being sent'
      redirect_to site_messages_path(@site)
    else
      render :action => :new
    end
  end
  
end