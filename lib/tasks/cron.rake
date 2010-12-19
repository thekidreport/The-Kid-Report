desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
 if Time.now.hour == 22 # run at 10pm
   Mailer::status_update(User.count, Site.count).deliver
 end
end
