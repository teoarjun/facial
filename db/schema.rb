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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170403091600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "name",                   default: "", null: false
    t.string   "image",                  default: "", null: false
    t.string   "gender",                 default: "", null: false
    t.date     "dob"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "comment"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "devices", force: :cascade do |t|
    t.string   "device_token"
    t.string   "device_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "images", force: :cascade do |t|
    t.string   "photo"
    t.text     "facial_response"
    t.integer  "story_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["story_id"], name: "index_images_on_story_id", using: :btree
  end

  create_table "likes", force: :cascade do |t|
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "status",        default: true
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "subject"
    t.string   "content"
    t.string   "notifiable_type"
    t.integer  "notifiable_id"
    t.boolean  "pending",         default: true
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "social_logins", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image"
    t.index ["user_id"], name: "index_social_logins_on_user_id", using: :btree
  end

  create_table "static_content_managements", force: :cascade do |t|
    t.string   "title",      default: ""
    t.text     "content",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "static_contents", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "time"
    t.string   "location"
    t.string   "status",     default: "public"
    t.index ["user_id"], name: "index_stories_on_user_id", using: :btree
  end

  create_table "story_tags", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "person_id"
    t.string   "tagged_name"
    t.index ["user_id"], name: "index_story_tags_on_user_id", using: :btree
  end

  create_table "user_groups", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id", using: :btree
    t.index ["user_id"], name: "index_user_groups_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: ""
    t.date     "dob"
    t.string   "gender",                 default: ""
    t.string   "name",                   default: ""
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address",                default: ""
    t.string   "image",                  default: ""
    t.string   "created_by",             default: "admin"
    t.string   "encrypted_password",     default: "",      null: false
    t.text     "bio",                    default: ""
    t.boolean  "noti_type",              default: true
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "access_token"
    t.boolean  "activate",               default: true
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "country"
    t.string   "facial_ipseity",         default: ""
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "view_stories", force: :cascade do |t|
    t.integer  "story_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_view_stories_on_story_id", using: :btree
    t.index ["user_id"], name: "index_view_stories_on_user_id", using: :btree
  end

  add_foreign_key "comments", "users"
  add_foreign_key "images", "stories"
  add_foreign_key "likes", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "social_logins", "users"
  add_foreign_key "stories", "users"
  add_foreign_key "story_tags", "users"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
  add_foreign_key "view_stories", "stories"
  add_foreign_key "view_stories", "users"
end
