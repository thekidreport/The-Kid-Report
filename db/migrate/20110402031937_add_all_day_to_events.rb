class AddAllDayToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :all_day, :boolean, :default => false, :null => false
    rename_column :events, :start_at, :start_on
    add_column :events, :start_time, :time
    rename_column :events, :end_at, :end_on
    add_column :events, :end_time, :time
    

    Event.reset_column_information
    for event in Event.all
      event.start_time = Time.new(event.start_on.year, event.start_on.month, event.start_on.day, ((event.start_on.hour + 17) % 24), event.start_on.min, event.start_on.sec, '-07:00')
      event.end_time = Time.new(event.end_on.year, event.end_on.month, event.end_on.day, ((event.end_on.hour + 17) % 24), event.end_on.min, event.end_on.sec, '-07:00') if event.end_on > event.start_on
      event.save
    end
    
  end

  def self.down
    remove_column :events, :all_day
    
    remove_column :events, :start_time
    rename_column :events, :start_on, :start_at
    
    remove_column :events, :end_time
    rename_column :events, :end_on, :end_at
  end
end
