class MakeMessagePolymorphic < ActiveRecord::Migration
  def self.up
    add_column :messages, :messageable_id, :integer
    add_column :messages, :messageable_type, :string
  end

  def self.down
    remove_column :messages, :messageable_id
    remove_column :messages, :messageable_type
  end
  
end
