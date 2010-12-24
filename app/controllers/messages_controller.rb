class MessagesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :site_editor_required!
  
  def index
    @messages = @site.messages.all.paginate(:page => params[:page])
  end
  
  def new
    @message = Message.new(params[:message])
    params[:recipients] = params[:recipients] || Array.new
  end
  
  def create
    @message = @site.messages.build(params[:message])
    @message.user = current_user
    if @message.save
      Mailer::site_message(@message).deliver
      flash[:confirmation] = 'Message was created and sent successfully'
      redirect_to site_messages_path(@site)
    else
      render :action => :new
    end
  end
  
end