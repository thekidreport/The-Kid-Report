class Event < ActiveRecord::Base
  
  has_event_calendar
  belongs_to :site
  belongs_to :page
  has_many :log_entries, :as => :loggable

  before_save :set_end_at, :set_remind_on
  
  attr_accessor :multi_day, :reminder
  
  scope :remind_today, lambda { where('Date(remind_on) = ?', Date.today)}
  scope :think_about, lambda { where('Date(start_at) > ?', 3.weeks.ago)}
  scope :coming_up, lambda { where('Date(start_at) between ? AND ?', Date.today, 4.weeks.from_now).order('start_at') }

  def set_end_at 
    self.end_at = self.start_at if self.end_at < self.start_at
    self.end_at = self.start_at if self.multi_day == '0'
  end
  
  def set_remind_on
    self.remind_on = nil if self.reminder == '0'
  end

end