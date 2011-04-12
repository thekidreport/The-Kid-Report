desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
 
  # Goes to Mark
  if User.where('created_at > ?', 1.hour.ago).not_deleted.first || Site.where('created_at > ?', 1.hour.ago).not_deleted.first
    Mailer::status_update(User.not_deleted.count, Site.not_deleted.count).deliver
  end
 
  if Time.now.hour == 8 # run at 8am
    Event.send_reminders
  end
 
end
