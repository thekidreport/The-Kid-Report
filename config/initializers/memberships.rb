Warden::Manager.after_authentication do |user,auth,opts|
  user.set_memberships
end