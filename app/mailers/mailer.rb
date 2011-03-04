class Mailer < ActionMailer::Base
  
  default :from => "support@thekidreport.org"

  def signup_thanks( user )
    @name = user.display_name
    mail( :from => 'mark@thekidreport.org', :to => user.email, :subject => "Thank you for registering with the Kid Report" ) do |format|
      format.html { render 'signup_thanks', :layout => 'application_mailer' }
    end
  end
  
  def site_message (message)    
    @message = message
    mail( :from => message.user.email, :to => message.users.not_deleted.map(&:email), :subject => message.subject ) do |format|
      format.html { render 'site_message' }
    end
  end
  
  def invite(membership)
    @site = membership.site
    @user = membership.user
    mail( :to => membership.user.email, :subject => "#{membership.site.name} Invitation" ) do |format|
      format.html { render 'site_invite', :layout => 'application_mailer' }
    end
  end
  
  # Cron
  def status_update (user_count, site_count)
    @user_count = user_count
    @site_count = site_count
    mail( :to => 'mark@thekidreport.org', :subject => "Kid Report status update" ) do |format|
      format.html { render 'status_update', :layout => 'application_mailer' }
    end
  end

  # Cron
  def site_update (site, user)
    @site = site
    mail( :to => user.email, :subject => "[The Kid Report] #{site.name} update" ) do |format|
      format.html { render 'site_update', :layout => 'application_mailer' }
    end
  end
  
  def event_reminder (site, user)
    @site = site
    mail( :to => user.email, :subject => "[The Kid Report] #{site.name} event notice" ) do |format|
      format.html { render 'event_reminder' }
    end
  end
  
  # Send feedback
  def site_feedback (feedback)
    @feedback = feedback
    mail( :to => 'mark@thekidreport.org', :subject => "Feedback" ) do |format|
      format.html { render 'feedback', :layout => 'application_mailer' }
    end
  end
  
  def new_user_alert(user)
    @user = user
    mail( :to => 'mark@thekidreport.org', :subject => "New User Signed up" ) do |format|
      format.html { render 'new_user_alert', :layout => 'application_mailer' }
    end
  end
end