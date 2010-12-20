class MessagesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :site_editor_required!
  
  def index
    @messages = @site.messages.paginate(:page => params[:page])
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
      return false
    else
      render :action => :new
      return false
    end
  end
  
  def edit
    @message = Message.find(params[:id])
    @site = @message.site
    if request.post?
      params[:recipients] = params[:recipients] || Array.new
      if params[:recipients].empty?
        flash[:error] = 'Please select a recipient'
        render :action => 'site_send_message'
        return false
      end
      @message.recipients.delete_all
      for r_id in params[:recipients]
        @message.recipients << Recipient.new(:user_id => r_id)
      end
      if @message.update_attributes(params[:message])
        flash[:confirmation] = 'Message was updated successfully'
        redirect_to :controller => 'site', :action => :messages, :site_id => @site
        return false
      end
    else
      params[:recipients] = Array.new
      for recipient in @message.recipients
        params[:recipients] << recipient.user_id.to_s
      end
    end
    render :action => 'site_send_message'
  end
  
  def destroy
    @message = Message.find(params[:id])
    @site = @message.site
    
    if request.post?
      if @message.sent
        flash[:confirm] = "Message cannot be deleted, it was already sent" 
      else
        @message.destroy      
        flash[:confirm] = "Message was deleted"
      end
    end
    
    redirect_to :controller => 'site', :action => :messages, :site_id => @site
    return false
  end
  
  
end
