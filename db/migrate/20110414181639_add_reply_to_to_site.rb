class AddReplyToToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :reply_to_email, :string
  end

  def self.down
    remove_column :sites, :reply_to_email
  end
end
