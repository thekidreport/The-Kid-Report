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
      flash[:notice] = 'Message was created successfully'
      respond_to do |format| 
        format.html { redirect_to site_messages_path(@site) }
        format.js { 
          render :update do |page|
            page.replace_html 'messages', :partial => "messages/page_messages", :locals => { :page => @message.page }
          end  
        }
      end
    else
      render :action => :new
    end
  end
  
  
  def destroy
    @page = @site.pages.not_deleted.find(params[:page_id])
    @message = @page.messages.find(params[:id])
    @message.destroy if (current_user.can_edit?(@site) || @message.user.eql?(current_user))
    LogEntry.create!(:loggable => @comment, :site => @site, :user => current_user, :description => 'comment_delete')
    render :update do |page|
      page.replace_html 'comments', :partial => "comments/page_comments", :locals => { :page => @comment.page }
    end
  end
  
end