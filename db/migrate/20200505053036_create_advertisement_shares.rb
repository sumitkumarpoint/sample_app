class CreateAdvertisementShares < ActiveRecord::Migration[5.2]
  def change
    create_table :advertisement_shares do |t|
      t.integer :user_id
      t.integer :advertisement_id

      t.timestamps
    end
  end
end
