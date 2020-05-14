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

ActiveRecord::Schema.define(version: 2020_05_13_102144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "advertisement_comment_attachments", force: :cascade do |t|
    t.string "media_file_name"
    t.string "media_content_type"
    t.integer "media_file_size"
    t.datetime "media_updated_at"
    t.integer "advertisement_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "advertisement_comments", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "advertisement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "advertisement_job_roles", force: :cascade do |t|
    t.string "name"
    t.integer "advertisement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "advertisement_likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "advertisement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "advertisement_locations", force: :cascade do |t|
    t.string "country"
    t.string "state"
    t.string "city"
    t.integer "advertisement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "advertisement_shares", force: :cascade do |t|
    t.integer "user_id"
    t.integer "advertisement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "advertisement_skills", force: :cascade do |t|
    t.string "name"
    t.integer "advertisement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "advertisements", force: :cascade do |t|
    t.string "campaign_name"
    t.string "objective"
    t.string "budget_type"
    t.decimal "budget_amount"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "age_from"
    t.integer "age_to"
    t.string "gender"
    t.string "media_type"
    t.string "media_file_name"
    t.string "media_content_type"
    t.integer "media_file_size"
    t.datetime "media_updated_at"
    t.text "primary_text"
    t.string "website_url"
    t.string "call_to_action"
    t.integer "user_id"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_advertisements_on_slug", unique: true
  end

  create_table "company_pages", force: :cascade do |t|
    t.string "profile_image_file_name"
    t.string "profile_image_content_type"
    t.integer "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.string "cover_image_file_name"
    t.string "cover_image_content_type"
    t.integer "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.string "page_identity"
    t.string "tagline"
    t.string "public_url"
    t.string "website"
    t.string "industry"
    t.string "company_size"
    t.string "street"
    t.string "address"
    t.string "zip_code"
    t.string "year_of_establishment"
    t.string "company_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public_url"], name: "index_company_pages_on_public_url", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "group_industries", force: :cascade do |t|
    t.string "industry"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "slug"
    t.string "profile_image_file_name"
    t.string "profile_image_content_type"
    t.integer "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.string "cover_image_file_name"
    t.string "cover_image_content_type"
    t.integer "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.string "name"
    t.text "description"
    t.string "location"
    t.boolean "is_private"
    t.boolean "allow_member_to_invite"
    t.boolean "require_to_be_review"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_groups_on_slug", unique: true
  end

  create_table "hashtag_followers", force: :cascade do |t|
    t.integer "hashtag_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_hashtags_on_slug", unique: true
  end

  create_table "jwt_blacklists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_blacklists_on_jti"
  end

  create_table "post_attachments", force: :cascade do |t|
    t.string "media_file_name"
    t.string "media_content_type"
    t.integer "media_file_size"
    t.datetime "media_updated_at"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_comment_attachments", force: :cascade do |t|
    t.string "media_file_name"
    t.string "media_content_type"
    t.integer "media_file_size"
    t.datetime "media_updated_at"
    t.integer "post_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_comments", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_hashtags", force: :cascade do |t|
    t.integer "hashtag_id"
    t.string "hashtag_slug"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_shares", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_viewers", force: :cascade do |t|
    t.integer "viewer_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "privacy_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end

  create_table "profile_viewers", force: :cascade do |t|
    t.integer "viewer_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_accomplishments", force: :cascade do |t|
    t.string "category"
    t.string "award_organization"
    t.string "website"
    t.string "location"
    t.string "award"
    t.datetime "date_received"
    t.integer "user_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_educations", force: :cascade do |t|
    t.string "university"
    t.string "website_url"
    t.string "location"
    t.string "degree"
    t.datetime "starting_from"
    t.datetime "ending_in"
    t.text "details"
    t.integer "user_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "profile_image_file_name"
    t.string "profile_image_content_type"
    t.integer "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.string "cover_image_file_name"
    t.string "cover_image_content_type"
    t.integer "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.datetime "birth_date"
    t.string "location"
    t.string "website"
    t.string "current_position"
    t.string "industry"
    t.text "summary"
    t.boolean "serving_notice_period"
    t.datetime "last_working_date"
    t.string "language"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_skills", force: :cascade do |t|
    t.string "name"
    t.integer "user_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_website_urls", force: :cascade do |t|
    t.string "provider"
    t.string "url"
    t.integer "user_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_work_experiences", force: :cascade do |t|
    t.string "title"
    t.integer "employment_type"
    t.string "company"
    t.string "location"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "still_working_here"
    t.text "description"
    t.integer "user_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "username", default: "", null: false
    t.string "uid", null: false
    t.string "phone"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

end
