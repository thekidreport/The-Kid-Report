class EventsController < ApplicationController

  before_filter :authenticate_user!, :except => :feed
  before_filter :authenticate_user!, :if => :site_members_only
  before_filter :site_editor_required!, :except => [:index, :show, :feed]
  
  before_filter :site_member_required!, :only => [:index, :show]
  before_filter :site_member_required!, :only => [:index, :show, :feed], :if => :site_members_only

  def index
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = @site.events.event_strips_for_month(@shown_month)
  end
  
  def feed
    respond_to do |format| 
      format.ics { render :text => (@site ? @site.ical.export : current_user.ical.export) }
    end
  end
  
  def show
    @event = @site.events.find(params[:id])
    render :layout => false
  end

  def new
    if params[:year] && params[:month] && params[:day]
      @start_on = Time.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}").to_datetime
      @end_on = Time.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}").to_datetime
      @start_time = Time.parse('12:00')
      @end_time = Time.parse('13:00')
      @remind_on = @start_on - 2.days
    end
    @event = @site.events.build(:start_on => @start_on, :end_on => @end_on, :start_time => @start_time, :end_time => @end_time, :remind_on => @remind_on, :reminder => false)
  end
  
  def create
    @event = @site.events.build(params[:event])
    if @event.save
      redirect_to site_events_path(:month => @event.start_on.month)
      return false
    else
      render :action => :new
    end
  end


  def edit
    @event = @site.events.find(params[:id])
    @event.reminder = @event.remind_on.present?
    @event.remind_on = @event.start_on - 2.days unless @event.remind_on
  end

  def update
    @event = @site.events.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = "Event was updated successfully"
      redirect_to site_events_path(:month => @event.start_on.month)
      return false
    else
      render :action => :edit
    end
  end
  
  def destroy
    @event = @site.events.find(params[:id])
    @event.destroy if @event
    redirect_to site_events_path(:month => @event.start_on.month)
  end
  
end
