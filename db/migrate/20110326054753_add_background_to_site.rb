class AddBackgroundToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :background_file_name, :string
    add_column :sites, :background_content_type, :string
    add_column :sites, :background_file_size, :integer
    add_column :sites, :background_repeat, :boolean
  end

  def self.down
    remove_column :sites, :background_file_name   
    remove_column :sites, :background_content_type
    remove_column :sites, :background_file_size
    remove_column :sites, :background_repeat
  end
end
