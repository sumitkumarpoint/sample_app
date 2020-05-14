class CreateAdvertisementSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :advertisement_skills do |t|
      t.string :name
      t.integer :advertisement_id

      t.timestamps
    end
  end
end
