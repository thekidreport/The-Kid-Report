class AttachmentController < ApplicationController
	
	before_filter :login_required, :except => [:show]
	
	def upload
	  @attachment = Attachment.new
	  @page = Page.find params[:page_id]
	  case request.method
    when :post
      if @attachment.update_attributes params[:attachment]
        @page.attachments << @attachment
        flash[:confirmation] = 'The attachment was successfully uploaded'
        redirect_to @page.uri
        return false
      else
        render :action => 'attachment_upload'
        return false
      end
    when :get
      render :action => 'attachment_upload'
      return false
    end
  end
  
	def edit
	  @attachment = Attachment.find params[:attachment_id]
  	@page = @attachment.page
	  case request.method
    when :post
      if @attachment.update_attributes( params[:attachment] )
        flash[:confirmation] = 'The attachment was successfully edited'
        redirect_to @page.uri
        return false
      end
    end  
    render :action => 'attachment_edit'
    return false
  end
  
  def delete
	  @attachment = Attachment.find params[:attachment_id]
  	@page = @attachment.page
  	
  	if @attachment.destroy && request.method == :post
      flash[:confirmation] = 'The attachment was deleted'
      redirect_to @page.uri
      return false
    else
      redirect_to @page.uri
      return false
    end
  end
  
end