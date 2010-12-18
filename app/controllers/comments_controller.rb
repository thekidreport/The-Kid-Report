class CommentsController < ApplicationController
  
  def create
    @page = @site.pages.find(params[:page_id])
    @comment = @page.comments.build(params[:comment].merge(:user => current_user))
    @comment.save
    render :update do |page|
      page.replace_html 'comments', :partial => "comments/page_comments", :locals => { :page => @comment.page }
    end
  end
  
  def destroy
    @page = @site.pages.find(params[:page_id])
    @comment = @page.comments.find(params[:id])
    @comment.destroy
    render :update do |page|
      page.replace_html 'comments', :partial => "comments/page_comments", :locals => { :page => @comment.page }
    end
  end
  
end