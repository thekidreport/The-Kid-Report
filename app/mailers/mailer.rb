class Mailer < ActionMailer::Base
  
  default :from => "support@thekidreport.com"

  def signup_thanks( user )
    @name = user.display_name
    mail( :from => 'mark@thekidreport.com', :to => user.email, :subject => "Thank you for registering with the Kid Report" ) do |format|
      format.html { render 'signup_thanks' }
    end
  end
  
  def site_message (message)    
    mail( :from => message.user.email, :to => message.recipients.map(&:email), :subject => message.subject ) do |format|
      format.html { render 'site_message' }
    end
  end
  
  # Cron
  def status_update (user_count, site_count)
    @user_count = user_count
    @site_count = site_count
    mail( :to => 'swards@gmail.com', :subject => "Kidreport status update" ) do |format|
      format.html { render 'status_update' }
    end
  end

  # Cron
  def site_update (user, site)
    @user = user
    @site = site
    mail( :to => user.email, :subject => "#{site.name} update" ) do |format|
      format.html { render 'site_update' }
    end
  end
  
  # Send email on comment
  
end