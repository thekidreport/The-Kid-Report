namespace :data do
  
  desc "Data manipulation"
  task :fix_messages => :environment do
    for message in Message.all
      if message.comment.try(:page)
        message.page = message.comment.page
        message.save
      end
    end
    for comment in Comment.all
      if comment.page
        Message.create(:site => comment.page.site, :page => comment.page, :comment => comment) if comment.message.nil?
      end
    end
  end
  
end