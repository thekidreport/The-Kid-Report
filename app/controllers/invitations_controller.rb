class InvitationsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :site_admin_required!
  
  def index
    @invitations = @site.invitations.all.paginate(:page => params[:page], :per_page => 20)
  end
  
  def relay
    @invitation = @site.invitations.find(params[:id])
    
    Mailer::invite(@invitation).deliver
    render :update do |page|
      page.replace "relay_#{dom_id(@invitation)}", :text => "<span style='color:red'>Invite sent!</span>"
    end
  end

  def new
    @invitation = @site.invitations.build
  end

  def create
    @invitation = @site.invitations.build(params[:invitation])
    if @invitation.save
      Mailer::invite(@invitation).deliver
      flash[:notice] = "The invitation was sent"
      redirect_to site_invitations_path(@site)
    else
      render :action => :new
    end
  end
  
  def new_many
    # nothing to do here.
  end
  
  def create_many
    potential_emails = params[:invitation_emails].split(/[<>\s,'"]+/)
    potential_emails = potential_emails.select{|e| e =~ User::EMAIL_REGEX }
          
    invitations_added_count = 0
    for potential_email in potential_emails
      invitation = @site.invitations.build(:email => potential_email)  
      if invitation.save  
        invitations_added_count += 1         
        Mailer::invite(invitation).deliver
      end
    end
    flash[:notice] = "#{invitations_added_count} new invitation#{invitations_added_count != 1 ? 's were' : ' was'  } sent"
    redirect_to site_invitations_path(@site)
  end
  
  def destroy
    @invitation = @site.invitations.find(params[:id]) 
    @invitation.destroy
    flash[:notice] = 'The invitation was deleted.'
    redirect_to site_invitations_path(@site)
  end
end
