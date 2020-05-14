class CreateProfileViewers < ActiveRecord::Migration[5.2]
  def change
    create_table :profile_viewers do |t|
      t.integer :viewer_id
      t.integer :user_id

      t.timestamps
    end
  end
end
