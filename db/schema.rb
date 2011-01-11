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

ActiveRecord::Schema.define(:version => 20110110062146) do

  create_table "awards", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "wine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", :force => true do |t|
    t.string   "token"
    t.date     "expiration_date"
    t.integer  "creditable_id"
    t.string   "creditable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "place"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "winery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "average_rating"
    t.decimal  "price",                :precision => 8, :scale => 2, :default => 0.0
    t.string   "contact_info_name"
    t.string   "contact_info_phone"
    t.string   "contact_info_email"
    t.string   "invitation_type"
  end

  create_table "favorites", :force => true do |t|
    t.string   "favorable_type"
    t.integer  "favorable_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.integer  "pictureable_id"
    t.string   "pictureable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "title"
  end

  create_table "rates", :force => true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars",         :null => false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], :name => "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], :name => "index_rates_on_rater_id"

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "specials", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "winery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.decimal  "average_rating",       :precision => 4, :scale => 2
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "plan_id"
    t.integer  "winery_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
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
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthdate"
    t.string   "telephone"
    t.string   "address"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.float    "lat"
    t.float    "lng"
    t.string   "movie_file_name"
    t.string   "movie_content_type"
    t.integer  "movie_file_size"
    t.datetime "movie_updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "videos", :force => true do |t|
    t.integer  "videoable_id"
    t.string   "videoable_type"
    t.string   "movie_file_name"
    t.string   "movie_content_type"
    t.integer  "movie_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "primary"
  end

  create_table "wineries", :force => true do |t|
    t.string   "email",                                                             :default => "",  :null => false
    t.string   "encrypted_password",   :limit => 128,                               :default => "",  :null => false
    t.string   "password_salt",                                                     :default => "",  :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                     :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "winery_name"
    t.string   "owner_gm_name"
    t.string   "owner_gm_email"
    t.string   "contact_first_name"
    t.string   "contact_last_name"
    t.string   "telephone"
    t.string   "address"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.string   "website_url"
    t.decimal  "rating_average",                      :precision => 6, :scale => 2, :default => 0.0
    t.float    "lat"
    t.float    "lng"
    t.integer  "average_rating"
  end

  add_index "wineries", ["confirmation_token"], :name => "index_wineries_on_confirmation_token", :unique => true
  add_index "wineries", ["email"], :name => "index_wineries_on_email", :unique => true
  add_index "wineries", ["reset_password_token"], :name => "index_wineries_on_reset_password_token", :unique => true

  create_table "wines", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",                :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "rating_average",       :precision => 6, :scale => 2, :default => 0.0
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "winery_id"
    t.string   "wine_type"
    t.string   "varietal"
    t.integer  "vintage"
    t.integer  "average_rating"
  end

end
