class CreateUserEducations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_educations do |t|
      t.string :university
      t.string :website_url
      t.string :location
      t.string :degree
      t.datetime :starting_from
      t.datetime :ending_in
      t.text :details
      t.integer :user_profile_id

      t.timestamps
    end
  end
end
