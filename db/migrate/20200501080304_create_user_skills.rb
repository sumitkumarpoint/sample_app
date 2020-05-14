class CreateUserSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :user_skills do |t|
      t.string :name
      t.integer :user_profile_id

      t.timestamps
    end
  end
end
