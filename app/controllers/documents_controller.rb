class DocumentsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :site_editor_required!
  
  def index
    @documents = @site.documents.all.paginate(:page => params[:page])
  end
  
  def show
    @document = @site.documents.find(params[:id])
    @page_title = @document.name
  end

  def new
    @document = @site.documents.build
  end

  def create
    @document = @site.documents.build(params[:document])
    @document.user = current_user
    if @document.save
      flash[:notice] = "Document was uploaded successfully"
      redirect_to site_documents_path(@site)
    else
      render :action => :new
    end
  end
  
  def download
    @document = @site.documents.find(params[:id])

    head(:not_found) and return if @document.nil?

    redirect_to(AWS::S3::S3Object.url_for(@document.file.path(:original), @document.file.bucket_name, :expires_in => 60.seconds))
  end

  def destroy
    @document = @site.documents.find(params[:id])
    @document.destroy
    flash[:notice] = "Document was deleted successfully"
    redirect_to site_documents_path(@site)
  end

end