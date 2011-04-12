class AddEmailToNotification < ActiveRecord::Migration
  def self.up
    add_column :notifications, :email, :string
    add_column :notifications, :created_at, :datetime
  end

  def self.down
    remove_column :notifications, :email
    remove_column :notifications, :created_at
  end
end
