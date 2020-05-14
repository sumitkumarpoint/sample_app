class CreateAdvertisementLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :advertisement_locations do |t|
      t.string :country
      t.string :state
      t.string :city
      t.integer :advertisement_id

      t.timestamps
    end
  end
end
