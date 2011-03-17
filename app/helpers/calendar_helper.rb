module CalendarHelper
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end
  
  # custom options for this calendar
  def event_calendar_opts
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>",
      :link_to_day_action => 'new'
      }
  end

  def event_calendar(options = {})
    # args is an argument hash containing :event, :day, and :options
    calendar event_calendar_opts.merge(options) do |args|
      event = args[:event]
      %(#{image_tag('icons/reminder.png', :title => event.remind_on.to_s(:date)) if event.remind_on.present?} #{link_to(image_tag('icons/link.png', :title => event.page.name), permalink_path(event.site.permalink, event.page.permalink)) if event.page.present?} #{link_to_if(current_user && current_user.can_edit?(event.site), event.name, "/sites/#{event.site.id}/events/#{event.id}/edit", :title => "#{event.name}#{": #{event.description}" if event.description.present?}")})
    end
  end
end
