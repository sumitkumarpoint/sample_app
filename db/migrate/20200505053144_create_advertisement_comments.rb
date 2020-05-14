class CreateAdvertisementComments < ActiveRecord::Migration[5.2]
  def change
    create_table :advertisement_comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :advertisement_id

      t.timestamps
    end
  end
end
