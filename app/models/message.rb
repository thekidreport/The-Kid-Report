class Message < ActiveRecord::Base
  belongs_to :site
  belongs_to :user # Author, usually.  Nil means site

  belongs_to :page
  belongs_to :comment
  belongs_to :event

  has_many :notifications

  validates_presence_of :body

  before_create :set_subject
  after_create :create_notifications

  def create_notifications
    for user in self.site.users
      self.notifications.create(:email => user.email)
    end
    for invite in self.site.invitations
      self.notifications.create(:email => invite.email)
    end
  end

  def set_subject
    self.subject = "#{self.site.name}"
    if self.page
      self.subject += ": #{self.page.name}"
    end
    if self.comment
      self.subject += " comment"
    end
    if self.event
      self.subject += " reminder: #{self.event.name}"
    end
    if self.user
      self.subject += ": a message from #{self.user.name}"
    end
  end
end