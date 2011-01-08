class Event < ActiveRecord::Base
  
  has_event_calendar
  belongs_to :site
  belongs_to :page

end