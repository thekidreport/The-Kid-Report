class ChangeRecipientToNotification < ActiveRecord::Migration
  def self.up
    rename_table :recipients, :notifications
  end

  def self.down
    rename_table :notifications, :recipients
  end
end
