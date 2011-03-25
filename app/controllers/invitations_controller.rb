class InvitationsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :site_admin_required!
  
  def index
    @invitations = @site.invitations.all
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
    if user = User.find_by_email(@invitation.email)
      if @site.users.include?(user) 
        flash[:notice] = "This user is already a member"
        render :action => :new
        return false
      elsif membership = @site.memberships.create(:user => user, :site => @invitation.site, :role => Role.member, :passcode => @invitation.site.passcode)        
        Mailer::confirm_membership(membership).deliver
        flash[:notice] = "The membership was created and a notice was sent"
        redirect_to site_memberships_path(@site)
      else  
        flash[:notice] = "The membership could not be created"
        redirect_to site_memberships_path(@site)
      end
    elsif @invitation.save
      Mailer::invite(@invitation).deliver
      flash[:notice] = "The invitation was sent"
      redirect_to site_invitations_path(@site)
    else
      render :action => :new
      return false
    end
  end
  
  def new_many
    # nothing to do here.
  end
  
  def create_many
    potential_emails = params[:invitation_emails].split(/[<>\s,'"]+/)
    potential_emails = potential_emails.select{|e| e =~ User::EMAIL_REGEX }    
    invitations_added_count = 0
    members_created_count = 0
    members_found_count = 0
    errors_count = 0
    for potential_email in potential_emails
      invitation = @site.invitations.build(:email => potential_email)  
      
      if user = User.find_by_email(invitation.email)
        if @site.users.include?(user) 
          members_found_count += 1
        elsif membership = @site.memberships.create(:user => user, :site => invitation.site, :role => Role.member, :passcode => invitation.site.passcode)        
          members_created_count += 1
          Mailer::confirm_membership(membership).deliver
        else  
          errors_count += 1
        end
      elsif invitation.save
        invitations_added_count += 1
        Mailer::invite(invitation).deliver
      end
      
    end
    flash[:notice] = "#{invitations_added_count} new invitation#{invitations_added_count != 1 ? 's were' : ' was'  } sent."
    flash[:notice] += " #{members_created_count} new member#{members_created_count != 1 ? 's were' : ' was'  } created." if members_created_count > 0
    flash[:notice] += " #{members_found_count} existing member#{members_found_count != 1 ? 's were' : ' was'  } found." if members_found_count > 0
    flash[:notice] += " #{errors_count} invitation#{members_found_count != 1 ? 's were' : ' was'  } not processed due to an error." if errors_count > 0
    
    redirect_to site_invitations_path(@site)
  end
  
  def destroy
    @invitation = @site.invitations.find(params[:id]) 
    @invitation.destroy
    flash[:notice] = 'The invitation was deleted.'
    redirect_to site_invitations_path(@site)
  end
end
