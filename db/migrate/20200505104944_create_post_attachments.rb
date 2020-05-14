class CreatePostAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :post_attachments do |t|
      t.attachment :media
      t.integer :post_id

      t.timestamps
    end
  end
end
