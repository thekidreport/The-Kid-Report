class CommentsController < ApplicationController
  
  def create
    @page = @site.pages.not_deleted.find(params[:page_id])
    @comment = @page.comments.build(params[:comment].merge(:user => current_user)) if current_user.member_of?(@site)
    LogEntry.create!(:loggable => @comment, :site => @site, :user => current_user, :description => 'comment_create') if @comment.save
    render :update do |page|
      page.replace_html 'comments', :partial => "comments/page_comments", :locals => { :page => @comment.page }
    end
  end
  
  def destroy
    @page = @site.pages.not_deleted.find(params[:page_id])
    @comment = @page.comments.find(params[:id])
    @comment.destroy if (current_user.can_edit?(@site) || @comment.user.eql?(current_user))
    LogEntry.create!(:loggable => @comment, :site => @site, :user => current_user, :description => 'comment_delete')
    render :update do |page|
      page.replace_html 'comments', :partial => "comments/page_comments", :locals => { :page => @comment.page }
    end
  end
  
end