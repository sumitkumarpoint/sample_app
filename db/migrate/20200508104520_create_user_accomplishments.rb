class CreateUserAccomplishments < ActiveRecord::Migration[5.2]
  def change
    create_table :user_accomplishments do |t|
      t.string :category
      t.string :award_organization
      t.string :website
      t.string :location
      t.string :award
      t.datetime :date_received
      t.integer :user_profile_id

      t.timestamps
    end
  end
end
