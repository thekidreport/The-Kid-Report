class AddEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.references :site, :page
      t.string :name
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.date :remind_on
    end
  end

  def self.down
    drop_table :events
  end
end
