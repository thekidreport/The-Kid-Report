class Event < ActiveRecord::Base
  
  has_event_calendar :start_at_field  => 'start_on', :end_at_field => 'end_on'
  
  belongs_to :site
  belongs_to :page
  has_many :log_entries, :as => :loggable
  has_many :messages
  
  validates_presence_of :name

  before_save :set_end_on, :set_remind_on
  
  attr_accessor :reminder
  # :multi_day was removed
  
  scope :remind_today, lambda { where('Date(remind_on) = ?', Date.today)}
  scope :think_about, lambda { where('Date(start_on) > ?', 1.weeks.ago).order(:start_on).limit(6)}
  scope :coming_up, lambda { where('Date(start_on) between ? AND ?', Date.today, 6.weeks.from_now).order('start_on, start_time') }
  scope :for_user, lambda { |user| where('memberships.user_id = ?', user.id).includes(:site => :memberships) }

  def set_end_on 
    self.end_on = self.start_on if self.end_on.blank?
    self.end_on = self.start_on if self.end_on < self.start_on
    self.end_time = self.start_time + 30.minutes if (self.end_on == self.start_on && self.end_time < self.start_time)
  end
  
  def set_remind_on
    self.remind_on = nil if self.reminder == '0'
  end
  
  def self.send_reminders
    for event in Event.remind_today
      event.site.messages.create(:event => event, :page => event.page, :body => "#{event.name} #{event.description}") unless event.messages.where('Date(created_at) = ?', Date.today).any?
    end
  end
  
  def assign_to_ical_event(ical_event)
    ical_event.summary = self.name.to_s
    ical_event.description = self.description.to_s
    if self.all_day? || self.start_time.blank?
      ical_event.dtstart =  self.start_at.strftime("%Y%m%d")
    else
      ical_event.dtstart =  self.start_at.strftime("%Y%m%d") + 'T' + self.start_time.strftime("%H%M%S")
    end
    if self.start_at < self.end_at
      ical_event.dtend = self.end_at.strftime("%Y%m%d") 
      if self.all_day? || self.end_time.blank?
        ical_event.dtend =  self.end_at.strftime("%Y%m%d")
      else
        ical_event.dtend =  self.end_at.strftime("%Y%m%d") + 'T' + self.end_time.strftime("%H%M%S")
      end
    end 
    ical_event.location = self.location.to_s
  end

end