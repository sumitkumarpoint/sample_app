class CreateAdvertisements < ActiveRecord::Migration[5.2]
  def change
    create_table :advertisements do |t|
      t.string :campaign_name
      t.string :objective
      t.string :budget_type
      t.decimal :budget_amount
      t.datetime :start_date
      t.datetime :end_date
      t.integer :age_from
      t.integer :age_to
      t.string :gender
      t.string :media_type
      t.attachment :media
      t.text :primary_text
      t.string :website_url
      t.string :call_to_action
      t.integer :user_id
      t.string  :slug, null:false
      t.index :slug, unique: true

      t.timestamps
    end
  end
end
