class CreatePostHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :post_hashtags do |t|
      t.integer :hashtag_id
      t.string :hashtag_slug
      t.integer :post_id

      t.timestamps
    end
  end
end
