class Event < ActiveRecord::Base
  
  has_event_calendar :start_at_field  => 'start_on', :end_at_field => 'end_on'
  
  belongs_to :site
  belongs_to :page
  has_many :log_entries, :as => :loggable
  has_many :messages
  
  validates_presence_of :name

  before_save :set_end_on, :set_remind_on
  
  attr_accessor :multi_day, :reminder
  
  scope :remind_today, lambda { where('Date(remind_on) = ?', Date.today)}
  scope :think_about, lambda { where('Date(start_on) > ?', 1.weeks.ago).order(:start_on).limit(6)}
  scope :coming_up, lambda { where('Date(start_on) between ? AND ?', Date.today, 6.weeks.from_now).order('start_on, start_time') }

  def set_end_on 
    self.end_on = self.start_on if self.end_on < self.start_on
    self.end_on = self.start_on if self.multi_day == '0'
  end
  
  def set_remind_on
    self.remind_on = nil if self.reminder == '0'
  end
  
  def self.send_reminders
    for event in Event.remind_today
      event.site.messages.create(:event => event, :page => event.page, :body => "#{event.name} #{event.description}") unless event.messages.where('Date(created_at) = ?', Date.today).any?
    end
  end

end