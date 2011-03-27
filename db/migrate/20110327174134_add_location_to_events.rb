class AddLocationToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :location, :string
  end

  def self.down
    add_column :events, :location
  end
end
