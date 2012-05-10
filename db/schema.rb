# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20111118032050) do

  create_table "authentications", :force => true do |t|
    t.integer  "winery_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.string   "access_secret"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "awards", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "wine_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "awards", ["wine_id"], :name => "index_awards_on_wine_id"

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["commentable_type", "commentable_id"], :name => "index_comments_on_commentable_type_and_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "credit_cards", :force => true do |t|
    t.string   "token"
    t.date     "expiration_date"
    t.integer  "creditable_id"
    t.string   "creditable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "credit_cards", ["creditable_type", "creditable_id"], :name => "index_credit_cards_on_creditable_type_and_creditable_id"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "place"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "winery_id"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.decimal  "average_rating",       :precision => 4, :scale => 2
    t.decimal  "price",                :precision => 8, :scale => 2, :default => 0.0
    t.string   "contact_info_name"
    t.string   "contact_info_phone"
    t.string   "contact_info_email"
    t.string   "invitation_type"
  end

  add_index "events", ["winery_id"], :name => "index_events_on_winery_id"

  create_table "favorites", :force => true do |t|
    t.string   "favorable_type"
    t.integer  "favorable_id"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "favorites", ["favorable_type", "favorable_id"], :name => "index_favorites_on_favorable_type_and_favorable_id"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "pictures", :force => true do |t|
    t.integer  "pictureable_id"
    t.string   "pictureable_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "title"
  end

  add_index "pictures", ["pictureable_type", "pictureable_id"], :name => "index_pictures_on_pictureable_type_and_pictureable_id"

  create_table "rates", :force => true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars",         :null => false
    t.string   "dimension"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "rates", ["rateable_id", "rateable_type"], :name => "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], :name => "index_rates_on_rater_id"

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.decimal  "rate",          :precision => 4, :scale => 2
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "ratings", ["rateable_type", "rateable_id"], :name => "index_ratings_on_rateable_type_and_rateable_id"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "registration_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.decimal  "price",      :precision => 8, :scale => 2
  end

  create_table "specials", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "winery_id"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.decimal  "average_rating",       :precision => 4, :scale => 2
  end

  add_index "specials", ["winery_id"], :name => "index_specials_on_winery_id"

  create_table "subscriptions", :force => true do |t|
    t.string   "plan_id"
    t.integer  "winery_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "subscriptions", ["winery_id"], :name => "index_subscriptions_on_winery_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                   :default => "", :null => false
    t.string   "encrypted_password",       :limit => 128, :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                           :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
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
    t.boolean  "accepts_terms_of_service"
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
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "title"
    t.boolean  "welcome"
    t.string   "youtube_id"
  end

  add_index "videos", ["videoable_type", "videoable_id"], :name => "index_videos_on_videoable_type_and_videoable_id"

  create_table "wineries", :force => true do |t|
    t.string   "email",                                                                 :default => "",  :null => false
    t.string   "encrypted_password",       :limit => 128,                               :default => "",  :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.datetime "created_at",                                                                             :null => false
    t.datetime "updated_at",                                                                             :null => false
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
    t.decimal  "rating_average",                          :precision => 6, :scale => 2, :default => 0.0
    t.float    "lat"
    t.float    "lng"
    t.float    "average_rating"
    t.string   "ownership_status"
    t.boolean  "accepts_terms_of_service"
    t.string   "price"
    t.boolean  "parking"
    t.boolean  "handicap"
    t.boolean  "fam_friendly"
    t.boolean  "restaurant"
    t.text     "descr"
    t.string   "hours"
    t.boolean  "credit_cards_accepted"
    t.boolean  "accept_credit"
  end

  add_index "wineries", ["confirmation_token"], :name => "index_wineries_on_confirmation_token", :unique => true
  add_index "wineries", ["email"], :name => "index_wineries_on_email", :unique => true
  add_index "wineries", ["reset_password_token"], :name => "index_wineries_on_reset_password_token", :unique => true

  create_table "wines", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.float    "price",                                                    :default => 0.0
    t.decimal  "rating_average",             :precision => 6, :scale => 2, :default => 0.0
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "winery_id"
    t.string   "wine_type"
    t.string   "varietal"
    t.integer  "vintage"
    t.float    "average_rating"
    t.string   "tasting_notes_file_name"
    t.string   "tasting_notes_content_type"
    t.integer  "tasting_notes_file_size"
    t.datetime "tasting_notes_updated_at"
  end

  add_index "wines", ["winery_id"], :name => "index_wines_on_winery_id"

end
