class CreateUserProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_profiles do |t|
      t.string :first_name
      t.string :last_name
      t.attachment :profile_image
      t.attachment :cover_image
      t.datetime :birth_date
      t.string :location
      t.string :website
      t.string :current_position
      t.string :industry
      t.text :summary
      t.boolean :serving_notice_period
      t.datetime :last_working_date
      t.string :language
      t.integer :user_id
      t.timestamps
    end
  end
end
