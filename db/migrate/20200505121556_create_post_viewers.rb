class CreatePostViewers < ActiveRecord::Migration[5.2]
  def change
    create_table :post_viewers do |t|
      t.integer :viewer_id
      t.integer :post_id

      t.timestamps
    end
  end
end
