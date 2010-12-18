class Mailer < ActionMailer::Base
  
  default :from => "support@thekidreport.com"

  def signup_thanks( user )
    @name = user.display_name
    mail( :from => 'mark@thekidreport.com', :to => user.email, :subject => "Thank you for registering with the Kid Report" ) do |format|
      format.html { render 'signup_thanks' }
    end
  end
  
  
  # The rest need to be cleaned up and added to cron jobs.
  def site_message (message)    
    content_type "text/html"
    recipients message.users.map(&:email)
    from 'support@thekidreport.com'
    @headers['Reply-to'] = message.user.email
    subject message.subject

    body :user => message.user, :site => message.site, :message => message.body.gsub(/$/,'<br>')
  end
  
  def status_update (user_count, site_count)
    recipients 'swards@gmail.com'
    from 'support@thekidreport.com'
    subject "Status update"
    
    body :user_count => user_count, :site_count => site_count
  end

  def site_update (user, site)
    # Email header info MUST be added here
    content_type "text/html"
    recipients user.email
    from 'support@thekidreport.com'
    subject "#{site.name} update"

    # Email body substitutions go here
    @body["user"]          = user
    @body["site"]          = site
  end
  
  def comment (comment)

    content_type "text/html"
    recipients 'support@thekidreport.com'
    if (comment.user)
      @headers['Reply-to'] = comment.user.email
      from comment.user.email
    end
    subject comment.subject
    body :comment => comment
    content_type "text/html" 
  end
  
end