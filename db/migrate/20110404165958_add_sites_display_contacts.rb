class AddSitesDisplayContacts < ActiveRecord::Migration
  def self.up
    add_column :sites, :display_contact_list, :boolean, :null => false, :default => false
    change_column :pages, :comments_allowed, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :sites, :display_contact_list
    change_column :pages, :comments_allowed, :boolean, :null => false, :default => false
  end
end
