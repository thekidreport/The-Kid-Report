class AddFieldsToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :members_only, :boolean, :default => true, :null => false
    add_column :sites, :passcode, :string, :default => 'abc123', :null => false
    add_column :sites, :auto_message, :boolean, :default => true, :null => false
    create_table :invitations do |t|
      t.string :email
      t.references :site
      t.timestamps
    end
  end

  def self.down
    remove_column :sites, :members_only
    remove_column :sites, :passcode
    remove_column :sites, :auto_message
    drop_table :invitations
  end
end
