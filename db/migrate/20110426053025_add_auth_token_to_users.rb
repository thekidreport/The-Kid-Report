class AddAuthTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :authentication_token, :string
    add_index :users, :authentication_token
  end

  def self.down
    remove_column :users, :authentication_token
    remove_index :users, :authentication_token
  end
end
