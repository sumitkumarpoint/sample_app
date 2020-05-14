class CreateUserWebsiteUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :user_website_urls do |t|
      t.string :provider
      t.string :url
      t.integer :user_profile_id

      t.timestamps
    end
  end
end
