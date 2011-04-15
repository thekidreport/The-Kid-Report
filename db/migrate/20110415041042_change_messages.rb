class ChangeMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :page_id, :integer
    add_column :messages, :comment_id, :integer
    add_column :messages, :event_id, :integer
    add_column :messages, :embed_page, :boolean, :default => false
    
    Message.reset_column_information
    for message in Message.all
      if message.messageable_type == 'Page'
        message.page_id = message.messageable_id
      elsif message.messageable_type == 'Event'
        message.event_id = message.messageable_id
        event = Event.find(message.messageable_id)
        message.page_id = event.page_id
      elsif message.messageable_type == 'Comment'
        message.comment_id = message.messageable_id
        comment = Comment.find(message.messageable_id)
        message.page_id = comment.page_id
      end
      message.save
    end
  end

  def self.down
    remove_column :messages, :page_id
    remove_column :messages, :comment_id
    remove_column :messages, :event_id
    remove_column :messages, :embed_page
  end
end
