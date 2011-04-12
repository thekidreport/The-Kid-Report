class Notification < ActiveRecord::Base
  belongs_to :message

  validates_presence_of :email
  
  after_create :add_to_queue
  
  def add_to_queue
    Delayed::Job.enqueue self
  end
  
  def perform
    Mailer::notification(self).deliver
  end  
  
end