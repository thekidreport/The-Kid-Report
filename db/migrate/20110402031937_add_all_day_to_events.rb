class AddAllDayToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :all_day, :boolean, :default => false, :null => false
    rename_column :events, :start_at, :start_on
    add_column :events, :start_time, :time
    rename_column :events, :end_at, :end_on
    add_column :events, :end_time, :time
  end

  def self.down
    remove_column :events, :all_day
    
    remove_column :events, :start_time
    rename_column :events, :start_on, :start_at
    
    remove_column :events, :end_time
    rename_column :events, :end_on, :end_at
  end
end
