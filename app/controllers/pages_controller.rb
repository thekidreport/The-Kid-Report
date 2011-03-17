class PagesController < ApplicationController
  
  before_filter :authenticate_user!, :if => :site_members_only
  before_filter :site_editor_required!, :except => :show
  before_filter :site_member_required!, :only => :show, :if => :site_members_only
  
  
  TINY_MCE_OPTIONS = { :theme => "advanced",
                              :plugins => [:table],
                              :theme_advanced_toolbar_align => "left",
                              :theme_advanced_buttons1 => "formatselect,bold,italic,forecolor,link,unlink,image,separator,bullist,numlist",
                              :theme_advanced_buttons2 => "justifyleft,justifycenter,separator,code,separator,tablecontrols",
                              :theme_advanced_buttons3 => "",
                              :theme_advanced_toolbar_location => "top",
                              :theme_advanced_statusbar_location => "bottom",
                              :theme_advanced_resizing => true,
                              :theme_advanced_resize_horizontal => false,
                              :theme_advanced_path => false,
                              :extended_valid_elements => "font[size|color|face]",
                              :external_image_list_url => '../../photos.js'
                            }
                            
  uses_tiny_mce :options => TINY_MCE_OPTIONS, :only => [:edit, :update]                         
  uses_tiny_mce :options => TINY_MCE_OPTIONS.merge(:external_image_list_url => '../photos.js'), :only => [:new, :create]
                            
  def show
    if params[:page_permalink]  
      if @page = @site.pages.not_deleted.find_by_permalink(params[:page_permalink])
        @page.increment!(:visitor_count)
      else
        render :text => 'Page not found', :status => :not_found
      end
    else
      @page = Page.new(:name => 'No Pages', :content => "This site has no pages.")
    end
  end
  
  def reorder
    @site.pages.not_deleted.each do | p |
      p.position = params["page_list"].index(p.id.to_s) + 1
      p.save
    end

    render :update do |page|
      page.replace_html 'page_list_table', :partial => 'page_list', :locals => {:site => @site}
    end
  end

  def new
    @page = @site.pages.build(params[:page])
  end

  def create
    @page = @site.pages.build(params[:page])
    @page.user = current_user

    if @page.save
      @page.archive
      LogEntry.create!(:page_archive => @page.page_archives.last, :site => @page.site, :user => current_user, :description => 'page_create')
      redirect_to permalink_path(@site.permalink, @page.permalink)
      return false
    else
      render :action => :new
    end

  end

  def edit
    @page_title = "Edit page"
    @page = @site.pages.not_deleted.find(params[:id])
    if params[:archive_id] && @page.page_archives
      @archive = @page.page_archives.find params[:archive_id]
      @page = @archive.page
    end
  end

  def update
    @page_title = "Edit page"
    @page = @site.pages.not_deleted.find(params[:id])
    @page.user = current_user
    if @page.update_attributes(params[:page])
      archive = @page.archive
      LogEntry.create!(:site => @page.site, :page_archive => archive, :user => current_user, :description => 'page_edit' )
      flash[:notice] = "Page was updated successfully"
      redirect_to permalink_path(@page.site.permalink, @page.permalink)
      return false
    else
      render :action => :edit
    end
  end
  
  def reset
    @page = Page.not_deleted.find(params[:id])
    @page.visitor_count = 0
    @page.visitor_count_start_at = Time.now 
    @page.save!
    redirect_to request.referer
  end
  
  def destroy
    @page = @site.pages.not_deleted.find(params[:id])
    @page.mark_deleted!
    archive = @page.archive
    LogEntry.create!(:site => @page.site, :page_archive => archive, :user => current_user, :description => 'page_delete' )
    flash[:confirm] = "The page was deleted"
    redirect_to site_pages_path(@site)
  end

end
