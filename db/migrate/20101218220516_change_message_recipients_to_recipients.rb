class ChangeMessageRecipientsToRecipients < ActiveRecord::Migration
  def self.up
    rename_table :message_recipients, :recipients
  end

  def self.down
    rename_table :recipients, :message_recipients
  end
end
