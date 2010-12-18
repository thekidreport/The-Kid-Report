class CreateInitialTables < ActiveRecord::Migration
  def self.up
    
    create_table "attachments", :force => true do |t|
      t.references :page, :document
      t.timestamps
    end

    create_table "comments", :force => true do |t|
      t.references :page, :user
      t.text "body", :default => "", :null => false
      t.timestamps
    end
    
    create_table "documents", :force => true do |t|
      t.references :site, :user
      t.string   "file_file_name"
      t.string   "file_content_type"
      t.integer  "file_file_size"
      t.timestamps
    end

    create_table "feedback", :force => true do |t|
      t.references :user
      t.string :subject, :referrer, :browser
      t.text :body, :null => false
      t.timestamps
    end

    create_table "log_entries", :force => true do |t|
      t.references :site, :page_archive, :user
      t.string :description
      t.datetime :created_at
    end

    create_table "memberships", :force => true do |t|
      t.references :site, :user, :role
      t.timestamps
    end

    create_table "message_recipients", :force => true do |t|
      t.references :message, :user
    end

    create_table "messages", :force => true do |t|
      t.references :site, :user
      t.string :subject
      t.text :body
      t.timestamps
    end

    create_table "page_archives", :force => true do |t|
      t.string :name, :null => false
      t.text :content
      t.references :page, :user
      t.datetime :created_at
    end

    create_table "pages", :force => true do |t|
      t.references :site, :user
      t.string :name, :null => false
      t.string :permalink, :null => false
      t.text :content
      t.boolean :comments_allowed, :default => false, :null => false
      t.datetime :last_edited_at
      t.integer :visitor_count, :default => 0
      t.datetime :visitor_count_start_at
      t.boolean :visible, :default => true
      t.integer :position, :default => 0
      t.timestamps
    end
    
    create_table "roles", :force => true do |t|
      t.string :name
    end
    

    create_table "sites", :force => true do |t|
      t.string :name
      t.string :description
      t.string :permalink, :null => false
      t.string :logo_file_name
      t.string :logo_content_type
      t.integer :logo_file_size
      t.string :time_zone
      t.datetime :last_edited_at
      t.text :footer
      t.string :background_color, :default => 'FFFFFF'
      t.string :body_color, :default => 'FFFFFF'
      t.string :highlight_color, :default => 'EEEEEE'
      t.string :font_color, :default => '000000'
      t.string :link_color, :default => '4488BB'
      t.timestamps
    end
    
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.timestamps
      t.string :name
      t.boolean :admin
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    
    
    Role.create(:name => 'Member')
    Role.create(:name => 'Editor')
    Role.create(:name => 'Admin')
    
  end

  def self.down
  end
end
