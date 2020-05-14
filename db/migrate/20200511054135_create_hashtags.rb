class CreateHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtags do |t|
      t.string :slug

      t.timestamps
    end
    add_index :hashtags, :slug, unique: true
  end
end
