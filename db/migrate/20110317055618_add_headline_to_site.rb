class AddHeadlineToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :top_story, :text
  end

  def self.down
    remove_column :sites, :top_story
  end
end
