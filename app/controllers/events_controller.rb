class EventsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :site_editor_required!, :except => [:index, :show]
  before_filter :site_member_required!, :only => [:index, :show]

  def index
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = @site.events.event_strips_for_month(@shown_month)
  end
  
  def show
    @event = @site.events.find(params[:id])
  end

  def new
    if params[:year] && params[:month] && params[:day]
      @start_at = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
      @end_at = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
      @remind_on = @start_at - 2.days
    end
    @event = @site.events.build(:start_at => @start_at, :end_at => @end_at, :remind_on => @remind_on, :reminder => false)
  end
  
  def create
    @event = @site.events.build(params[:event])
    if @event.save
      redirect_to site_events_path(:month => @event.start_at.month)
      return false
    else
      render :action => :new
    end

  end


  def edit
    @event = @site.events.find(params[:id])
    @event.reminder = @event.remind_on.present?
    @event.multi_day = @event.end_at && @event.end_at > @event.start_at
  end

  def update
    @event = @site.events.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = "Event was updated successfully"
      redirect_to site_events_path(:month => @event.start_at.month)
      return false
    else
      render :action => :edit
    end
  end
  
  def destroy
    @event = @site.events.find(params[:id])
    @event.destroy if @event
    redirect_to site_events_path(:month => @event.start_at.month)
  end
  
end
