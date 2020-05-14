class CreateAdvertisementCommentAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :advertisement_comment_attachments do |t|
      t.attachment :media
      t.integer :advertisement_comment_id

      t.timestamps
    end
  end
end
