class Mailer < ActionMailer::Base
  default :from => "support@thekidreport.org"

  def signup_thanks( user )
    @name = user.display_name
    mail( :from => 'mark@thekidreport.org', :to => user.email, :subject => "[The Kid Report] Thank you for registering" ) do |format|
      format.html { render 'signup_thanks', :layout => 'application_mailer' }
    end
  end
  
  def site_message (message)    
    @message = message
    mail( :from => message.user.email, :to => message.users.not_deleted.map(&:email), :subject => message.subject ) do |format|
      format.html { render 'site_message' }
    end
  end

  def invite(invite)
    @site = invite.site
    @email = invite.email
    mail( :to => @email, :subject => "[The Kid Report] #{invite.site.name} Invitation" ) do |format|
      format.html { render 'site_invite', :layout => 'application_mailer' }
    end
  end

  def confirm_membership(membership)
    @site = membership.site
    @user = membership.user
    mail( :to => @user.email, :subject => "[The Kid Report] #{membership.site.name} Invitation" ) do |format|
      format.html { render 'site_membership_confirmation', :layout => 'application_mailer' }
    end
  end

  # Cron
  def status_update (user_count, site_count)
    @user_count = user_count
    @site_count = site_count
    mail( :to => 'mark@thekidreport.org', :subject => "The Kid Report status update" ) do |format|
      format.html { render 'status_update', :layout => 'application_mailer' }
    end
  end

  # Cron
  def site_update(site, user)
    @site = site
    mail( :to => user.email, :subject => "[The Kid Report] #{site.name} update" ) do |format|
      format.html { render 'site_update', :layout => 'application_mailer' }
    end
  end
  
  def notification(notification)
    @notification = notification
    @message = @notification.message
    @site = @message.site
    @user = User.find_by_email(notification.email)
    
    if @message.messageable.is_a? Page
      @message.messageable.documents.each do |a|
        tempfile = File.new("#{Rails.root.to_s}/tmp/#{a.file_file_name}", "w")
        tempfile << open(a.file.url)
        tempfile.puts
        attachments[a.file_file_name] = File.read("#{Rails.root.to_s}/tmp/#{a.file_file_name}")
        # Delete it tempfile
        # File.delete("#{Rails.root.to_s}/tmp/#{a.file_file_name}")
      end
    
    end
    mail( :to => notification.email, :subject => @message.subject, :reply_to => @site.reply_to_email ) do |format|
      format.html { render 'notification', :layout => 'application_mailer' }
    end
  end
  
  def site_teaser (site, invitation)
    @site = site
    @invitation = invitation
    mail( :to => invitation.email, :subject => "[The Kid Report] #{site.name} news" ) do |format|
      format.html { render 'site_teaser', :layout => 'application_mailer' }
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
  
  
  # Not used
  def new_user_alert(user)
    @user = user
    mail( :to => 'mark@thekidreport.org', :subject => "New User Signed up" ) do |format|
      format.html { render 'new_user_alert', :layout => 'application_mailer' }
    end
  end
end