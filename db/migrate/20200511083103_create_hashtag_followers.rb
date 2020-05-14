class CreateHashtagFollowers < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtag_followers do |t|
      t.integer :hashtag_id
      t.integer :user_id

      t.timestamps
    end
  end
end
