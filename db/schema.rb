# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090728122028) do

  create_table "forums", :force => true do |t|
    t.string "name",        :null => false
    t.string "title",       :null => false
    t.text   "description", :null => false
  end

  add_index "forums", ["name"], :name => "index_forums_on_name", :unique => true

  create_table "people", :force => true do |t|
    t.string   "email",         :null => false
    t.string   "password_hash", :null => false
    t.string   "name"
    t.string   "nick",          :null => false
    t.string   "url"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "people", ["email"], :name => "index_people_on_email", :unique => true

  create_table "posts", :force => true do |t|
    t.integer "subject_id", :null => false
    t.integer "person_id",  :null => false
  end

  add_index "posts", ["person_id"], :name => "index_posts_on_person_id"
  add_index "posts", ["subject_id"], :name => "index_posts_on_thread_id"

  create_table "revisions", :force => true do |t|
    t.integer  "post_id",    :null => false
    t.string   "body",       :null => false
    t.datetime "created_at", :null => false
  end

  add_index "revisions", ["created_at"], :name => "index_revisions_on_created_at"
  add_index "revisions", ["post_id"], :name => "index_revisions_on_post_id"

  create_table "subjects", :force => true do |t|
    t.integer "forum_id", :null => false
    t.string  "title",    :null => false
  end

  add_index "subjects", ["title"], :name => "index_post_threads_on_subject"
  add_index "subjects", ["forum_id"], :name => "index_post_threads_on_forum_id"

end
