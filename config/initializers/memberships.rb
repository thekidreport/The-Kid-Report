Warden::Manager.after_authentication do |user,auth,opts|
  user.invitations.each {|i| Membership.create(:user => user, :site => i.site, :role => Role.member, :passcode => i.site.passcode) }
end