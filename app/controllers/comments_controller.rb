class CommentsController < ApplicationController
  
  def create
    @page = @site.pages.find(params[:page_id])
    @comment = @page.comments.build(params[:comment].merge(:user => current_user)) if current_user.member_of?(@site)
    @comment.save
    render :update do |page|
      page.replace_html 'comments', :partial => "comments/page_comments", :locals => { :page => @comment.page }
    end
  end
  
  def destroy
    @page = @site.pages.find(params[:page_id])
    @comment = @page.comments.find(params[:id])
    @comment.destroy if (current_user.can_edit?(@site) || @comment.user.eql?(current_user))
    render :update do |page|
      page.replace_html 'comments', :partial => "comments/page_comments", :locals => { :page => @comment.page }
    end
  end
  
end