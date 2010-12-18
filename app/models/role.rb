class Role < ActiveRecord::Base
    
  def self.admin
    Role.where("name = 'Admin'").first
  end

  def self.editor
    Role.where("name = 'Editor'").first
  end

  def self.member
    Role.where("name = 'Member'").first
  end

end