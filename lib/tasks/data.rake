namespace :data do
  
  desc "Data manipulation"
  task :fix_messages => :environment do
    Message.skip_callback(:create, :after, :create_instant_notifications)
    for message in Message.all
      if message.comment.try(:page)
        message.page = message.comment.page
        message.save
      end
    end  
    for comment in Comment.all
      if comment.message.nil?
        Message.create(:site => comment.page.site, :page => comment.page, :comment => comment, :body => comment.body, :user => comment.user)
        puts "created message for page: #{comment.page.site.name} - #{comment.page.name}"
      elsif comment.message.present? and comment.message.user.nil?
        comment.message.user = comment.user
        comment.message.save
      end
    end
    for message in Message.all
      if comment = message.comment
        Message.connection.update("UPDATE messages set created_at = '#{comment.created_at}', updated_at = '#{comment.updated_at}' where id = #{message.id}")
      end
    end
    Message.set_callback(:create, :after, :create_instant_notifications)
  end
  
end