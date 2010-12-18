class PagesController < ApplicationController
  
  before_filter :authenticate_user!
  
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
    @site = Site.find_by_permalink(params[:site_permalink])
    unless @site
      render :text => 'Page not found', :status => :not_found
      return false
    end
    if params[:page_permalink]  
      @page = @site.pages.find_by_permalink(params[:page_permalink])
      @page.increment!(:visitor_count)
    elsif @site.home_page
      redirect_to permalink_path(@site.permalink, @site.home_page.permalink)
    else
      @page = Page.new(:name => 'No Pages', :content => "This site has no pages.")
    end
  end
  
  def reorder
    @site.pages.each do | p |
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
      @page.site.last_edited_at = Time.now
      @page.site.save
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
    @include_rte = true
    @page = @site.pages.find (params[:id])
    if params[:archive_id] && @page.page_archives
      @archive = @page.page_archives.find params[:archive_id]
      @page = @archive.page
    end
  end

  def update
    @page_title = "Edit page"
    @include_rte = true
    @page = @site.pages.find (params[:id])
    @page.user = current_user
    @page.set_last_edited_at
    if @page.update_attributes(params[:page])
      @page.site.save
      @page.archive
      LogEntry.create!(:site => @page.site, :page_archive => @page.page_archives.last, :user => @user, :description => 'page_edit' )
      flash[:notice] = "Page was updated successfully"
      redirect_to permalink_path(@page.site.permalink, @page.permalink)
      return false
    else
      render :action => :edit
    end
  end
  
  def reset
    @page = Page.find params[:id]
    @page.visitor_count = 0
    @page.visitor_count_start_at = Time.now 
    @page.save!
    redirect_to request.referer
  end
  
  def destroy
    @page = @site.pages.find(params[:id])
    @page.destroy
    LogEntry.create!(:site => @page.site, :page_archive => @page.page_archives.last, :user => @user, :description => 'page_delete' )
    flash[:confirm] = "The page was deleted"
    redirect_to site_pages_path(@site)
  end

end
