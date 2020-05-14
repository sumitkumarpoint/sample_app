class CreatePostCommentAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :post_comment_attachments do |t|
      t.attachment :media
      t.integer :post_comment_id

      t.timestamps
    end
  end
end
