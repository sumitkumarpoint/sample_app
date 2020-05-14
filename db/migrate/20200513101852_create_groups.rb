class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :slug
      t.attachment :profile_image
      t.attachment :cover_image
      t.string :name
      t.text :description
      t.string :location
      t.boolean :is_private
      t.boolean :allow_member_to_invite
      t.boolean :require_to_be_review
      t.integer :user_id

      t.timestamps
    end
    add_index :groups, :slug, unique: true
  end
end
