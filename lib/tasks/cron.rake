desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
 if Time.now.hour == 22 # run at 10pm
   Mailer::status_update(User.not_deleted.count, Site.not_deleted.count).deliver
 end
 
 for site in Site.with_recent_changes
   Mailer::site_update(site).deliver
 end
 
end
