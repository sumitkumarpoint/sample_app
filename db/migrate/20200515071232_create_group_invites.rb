class CreateGroupInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :group_invites do |t|
      t.string :email
      t.integer :group_id
      t.integer :sender_id
      t.integer :recipient_id
      t.string :token

      t.timestamps
    end
    add_index :group_invites, :token, unique: true
  end
end
