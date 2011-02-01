class Event < ActiveRecord::Base
  
  has_event_calendar
  belongs_to :site
  belongs_to :page

  before_save :set_end_at, :set_remind_on
  
  attr_accessor :multi_day, :reminder
  
  scope :remind_today, lambda { where('Date(remind_on) = ?', Date.today)}
  scope :this_month, lambda { where('Month(start_at) = ?', Date.today.month)}

  def set_end_at 
    self.end_at = self.start_at if self.end_at < self.start_at
    self.end_at = self.start_at if self.multi_day == '0'
  end
  
  def set_remind_on
    self.remind_on = nil if self.reminder == '0'
  end

end