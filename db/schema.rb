# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110318162436) do

  create_table "attachments", :force => true do |t|
    t.integer  "page_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "page_id"
    t.integer  "user_id"
    t.text     "body",       :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.integer  "site_id"
    t.integer  "user_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "site_id"
    t.integer  "page_id"
    t.string   "name"
    t.text     "description"
    t.datetime "start_at"
    t.datetime "end_at"
    t.date     "remind_on"
  end

  create_table "feedback", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.string   "referrer"
    t.string   "browser"
    t.text     "body",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.string   "email"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_entries", :force => true do |t|
    t.integer  "site_id"
    t.integer  "loggable_id"
    t.integer  "user_id"
    t.string   "description"
    t.datetime "created_at"
    t.string   "loggable_type"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "site_id"
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "site_id"
    t.integer  "user_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_archives", :force => true do |t|
    t.string   "name",       :null => false
    t.text     "content"
    t.integer  "page_id"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "site_id"
    t.integer  "user_id"
    t.string   "name",                                      :null => false
    t.string   "permalink",                                 :null => false
    t.text     "content"
    t.boolean  "comments_allowed",       :default => false, :null => false
    t.datetime "last_edited_at"
    t.integer  "visitor_count",          :default => 0
    t.datetime "visitor_count_start_at"
    t.boolean  "visible",                :default => true
    t.integer  "position",               :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "recipients", :force => true do |t|
    t.integer "message_id"
    t.integer "user_id"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "permalink",                               :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.string   "time_zone"
    t.datetime "last_edited_at"
    t.text     "footer"
    t.string   "background_color",  :default => "FFFFFF"
    t.string   "body_color",        :default => "FFFFFF"
    t.string   "highlight_color",   :default => "EEEEEE"
    t.string   "font_color",        :default => "000000"
    t.string   "link_color",        :default => "4488BB"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "members_only",      :default => true,     :null => false
    t.string   "passcode",          :default => "abc123", :null => false
    t.boolean  "auto_message",      :default => true,     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "admin"
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
