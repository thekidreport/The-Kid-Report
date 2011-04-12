class Message < ActiveRecord::Base
  belongs_to :site
  belongs_to :user # Author, usually.  Nil means site
  belongs_to :messageable, :polymorphic => true

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
    if self.messageable.is_a? Comment
      self.subject = "#{self.site.name} comment: #{self.messageable.page.name}"
    elsif self.messageable.is_a? Page
      self.subject = "#{self.site.name}: #{self.messageable.name}"
    elsif self.messageable.is_a? Event
      self.subject = "#{self.site.name} reminder: #{self.messageable.name}"
    else
      self.subject = "#{self.site.name} message from #{self.user.try(:name)} "
    end
  end
end