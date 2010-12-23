class AddDeletedAtToUsersSitesPages < ActiveRecord::Migration
  def self.up
    add_column :users, :deleted_at, :datetime
    add_column :pages, :deleted_at, :datetime
    add_column :sites, :deleted_at, :datetime
  end

  def self.down
    add_column :users, :deleted_at
    add_column :pages, :deleted_at
    add_column :sites, :deleted_at
  end
end
